require 'bloom'

class TokenController < ApplicationController
  SOURCES = {"de" => S01, "en" => S02, "es" => S03, "fr" => S04, "it" => S05, "nl" => S06}
  BLOOM_SIZE = 24000
  def token
    w = params[:id]
    source = SOURCES[params[:source]]
    @token = source::Token.where(word: w).first
    unless @token
      flash[:search] = "Word #{w} not found."
      render :index
      return
    end
=begin
    @twograms = @token.twograms
    
    @g3ss = source::G3.for_tokens([@token])
    prec_2grams = @g3ss[2].inject({}) {|memo,g3| memo[g3.wtoken2_id] ||= 0;memo[g3.wtoken2_id] += g3.frequency;memo}.reject {|k,f| f < 3}
    next_2grams = @g3ss[0].inject({}) {|memo,g3| memo[g3.wtoken2_id] ||= 0;memo[g3.wtoken2_id] += g3.frequency;memo}.reject {|k,f| f < 3}
    
    @g3ss_reduced = @g3ss.map {|x| x[0,50] }
    wtokens = @g3ss_reduced.flatten.map {|x| [x.wtoken1_id,x.wtoken2_id,x.wtoken3_id]}.flatten.uniq
    ws = source::Token.where(id: wtokens).all
    @token_map = ws.select(&:word).inject({}) { |memo,t| memo[t.id]=t.word ; memo }
    ws = ws.reject(&:word).inject({}) {|memo,x| memo[x.id] = [x.wtoken1_id,x.wtoken2_id];memo}
    
    g2map = source::Token.where(id: ws.values.flatten - @token_map.keys).inject({}) { |memo,t| memo[t.id]=t.word ; memo }
    find_words = -> wt1,wt2 { [@token_map[wt1] || g2map[wt1],@token_map[wt2] || g2map[wt2]]}
    ws.each {|tid,(wt1,wt2)| @token_map[tid] = find_words[wt1,wt2] }
    
    id2word = -> t { t == 0 ? nil : (@token_map[t] || @token.class.find(t).word)}
    
    @twograms = @twograms.map {|x| x.map {|t,f| [id2word[t], f] }}
    id2word = -> t {@token_map[t] || @token.class.find(t).word}
    pv_2g = source::Token.where(id: prec_2grams.keys).map{|t| [t.word || id2word[t.wtoken2_id], prec_2grams[t.id]] }.sort_by(&:second).reverse
    nx_2g = source::Token.where(id: next_2grams.keys).map{|t| [t.word || id2word[t.wtoken1_id], next_2grams[t.id]] }.sort_by(&:second).reverse
    @twograms[0] += pv_2g
    @twograms[1] += nx_2g
=end  
  end
  
  def json_token
    w = params[:word]
    # return render(:json => {"token" => {"frequency" => 0,"id" => 0,"occurrence_statistics" => "","word" => "#"}}) if w.to_i.zero?
    source = SOURCES[params[:source]]
    token = source::Token.where(word: w).first
    render :json => token
  end
  
  def json_bigram
    d = params[:distance]
    conditions = {}
    t = params[:t1] and conditions[:token1_id] = t
    t = params[:t2] and conditions[:token2_id] = t
    return(head 500) if conditions.empty?
    conditions[:distance] = d
    
    source = SOURCES[params[:source]]
    bg = source::Bigram.where(conditions).limit(100).order("frequency desc").offset(100*params[:page].to_i).all
    render :json => bg
  end
  
  def json_trigram
    conditions = {}
    t = params[:t1] and conditions[:token1_id] = t
    t = params[:t2] and conditions[:token2_id] = t
    t = params[:t3] and conditions[:token3_id] = t
    return(head 500) if conditions.empty?
    
    source = SOURCES[params[:source]]
    bg = source::Trigram.where(conditions).limit(100).order("frequency desc").offset(100*params[:page].to_i).all
    render :json => bg
  end

  def json_examples
    w = params[:word]
    find_sentences_for_item(w)
  end
  
  private
  
  def find_sentences_for_item(phrase)
    source = SOURCES[params[:source]]
    words = phrase.split
    item = if words.size == 1
      words[0]
    elsif words.size == 2
      ts = words.map {|x| x == '*' ? nil : x == '#' ? 0 : token_id_for_word(x) }.compact
      if ts.size == 1
        words.delete ?*
        words.first
      else
        bg = source::Bigram.where(distance: 0, token1_id: ts[0], token2_id: ts[1]).first
        bg and puts "frequency is #{bg.frequency}"
        "0:" + ts.join(?,)
      end
    else
      ts = words.map {|x| x == '*' ? nil : x == '#' ? 0 : token_id_for_word(x) }
      raise 'not implemented'
    end
    puts "looking for \"#{item}\""
    offsets = Bloom.offsets(item, BLOOM_SIZE).sort
    sentences = []
    File.open("#{ENV['HOME']}/corpora/process/#{params[:source]}/bloom") do |f|
      page = 0
      loop do
        r = offsets.all? do |i|
          f.seek(page*BLOOM_SIZE/8 + i/8)
          c = f.getc or raise "not found"
          # puts "seek page(#{page+1}), bit(#{i}), found byte(#{c.getbyte(0)}), value(#{c.getbyte(0) & (1 << (i % 8))})"
          c.getbyte(0) & (1 << (i % 8)) != 0
        end
        if r
          source::Seq.for_id(page+1).grep(/#{phrase}/i).each {|s| sentences << s }
        end
        break if sentences.size == 10
        page += 1
      end
    end
    # TODO normalize completely (check pipeline)
    render :json => sentences.inspect + "\n"
  end
  
  def token_id_for_word(x)
    source = SOURCES[params[:source]]
    r = source::Token.where(word: x).first
    r and return r.id
    raise x
  end
end

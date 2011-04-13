require 'bloom'

class TokenController < ApplicationController
  include ApplicationHelper
  SOURCES = {"de" => S01, "en" => S02, "es" => S03, "fr" => S04, "it" => S05, "nl" => S06}
  BLOOM_SIZE = 24000
  COMMON_WORDS = {}

=begin
If "fact 74 (met gnief)" is frequent and "fact 60 (gnief te)" is frequent and "fact 10 (ik gnief)" is infrequent , P(noun&fact) + P(~noun&~fact) is 0.895
If "fact 60 (gnief te)" is frequent and "fact 10 (ik gnief)" is infrequent and "fact 2 (de gnief)" is frequent , P(noun&fact) + P(~noun&~fact) is 0.895
If "fact 60 (gnief te)" is frequent and "fact 32 (gnief haar)" is frequent and "fact 10 (ik gnief)" is infrequent , P(noun&fact) + P(~noun&~fact) is 0.895
If "fact 60 (gnief te)" is frequent and "fact 42 (van gnief)" is frequent and "fact 10 (ik gnief)" is infrequent , P(noun&fact) + P(~noun&~fact) is 0.895
If "fact 76 (gnief naar)" is frequent and "fact 40 (gnief van)" is infrequent and "fact 34 (haar gnief)" is infrequent , P(name&fact) + P(~name&~fact) is 0.940
If "fact 77 (gnief * naar)" is frequent and "fact 51 (zijn * gnief)" is infrequent and "fact 39 (niet * gnief)" is frequent , P(name&fact) + P(~name&~fact) is 0.940
If "fact 40 (gnief van)" is infrequent and "fact 36 (gnief niet)" is frequent and "fact 35 (haar * gnief)" is infrequent , P(name&fact) + P(~name&~fact) is 0.940
If "fact 47 (in * gnief)" is infrequent and "fact 40 (gnief van)" is infrequent and "fact 36 (gnief niet)" is frequent , P(name&fact) + P(~name&~fact) is 0.935
If "fact 67 (was * gnief)" is frequent and "fact 23 (ze * gnief)" is frequent and "fact 17 (gnief * een)" is infrequent , P(adjective&fact) + P(~adjective&~fact) is 0.905
If "fact 65 (gnief * was)" is frequent and "fact 23 (ze * gnief)" is frequent and "fact 17 (gnief * een)" is infrequent , P(adjective&fact) + P(~adjective&~fact) is 0.905
If "fact 65 (gnief * was)" is frequent and "fact 27 (hij * gnief)" is frequent and "fact 17 (gnief * een)" is infrequent , P(adjective&fact) + P(~adjective&~fact) is 0.905
If "fact 23 (ze * gnief)" is frequent and "fact 17 (gnief * een)" is infrequent and "fact 10 (ik gnief)" is frequent , P(adjective&fact) + P(~adjective&~fact) is 0.905
If "fact 78 (naar gnief)" is frequent and "fact 60 (gnief te)" is infrequent and "fact 20 (gnief ze)" is frequent , P(verb&fact) + P(~verb&~fact) is 0.865
If "fact 60 (gnief te)" is infrequent and "fact 32 (gnief haar)" is frequent and "fact 20 (gnief ze)" is frequent , P(verb&fact) + P(~verb&~fact) is 0.865
If "fact 74 (met gnief)" is frequent and "fact 60 (gnief te)" is infrequent and "fact 20 (gnief ze)" is frequent , P(verb&fact) + P(~verb&~fact) is 0.865
If "fact 70 (maar gnief)" is frequent and "fact 60 (gnief te)" is infrequent and "fact 20 (gnief ze)" is frequent , P(verb&fact) + P(~verb&~fact) is 0.865

=end
  def token
    w = params[:id]
    source = SOURCES[params[:source]]
    @token = source::Token.where(word: w).first
    unless @token
      flash[:search] = "Word #{w} not found." unless w.blank?
      render :index
      return
    end
    dist0_succ = source::Bigram.where(token1_id: @token.id, distance: 0).order("frequency desc").limit(50)
    hwords = source::Token.where(id: dist0_succ.map(&:token2_id)).each_with_object({}) {|t,h| h[t.id] = t.word}
    @bigram_succ = dist0_succ.map {|b| [hwords[b.token2_id], b.frequency] }
    
    dist0_prec = source::Bigram.where(token2_id: @token.id, distance: 0).order("frequency desc").limit(50)
    hwords = source::Token.where(id: dist0_prec.map(&:token1_id)).each_with_object({}) {|t,h| h[t.id] = t.word}
    @bigram_prec = dist0_prec.map {|b| [hwords[b.token1_id], b.frequency] }

    g3_1 = source::Trigram.where(token1_id: @token.id).order("frequency desc").limit(10)
    hwords = source::Token.where(id: g3_1.map(&:token2_id) + g3_1.map(&:token3_id)).each_with_object({}) {|t,h| h[t.id] = t.word}
    @g3_1 = g3_1.map {|b| ["#{w} #{hwords[b.token2_id] || '#'} #{hwords[b.token3_id] || '#'}", b.frequency] }
    
    g3_2 = source::Trigram.where(token2_id: @token.id).order("frequency desc").limit(20)
    hwords = source::Token.where(id: g3_2.map(&:token1_id) + g3_2.map(&:token3_id)).each_with_object({}) {|t,h| h[t.id] = t.word}
    @g3_2 = g3_2.map {|b| ["#{hwords[b.token1_id] || '#'} #{w} #{hwords[b.token3_id] || '#'}", b.frequency] }
    
    g3_3 = source::Trigram.where(token3_id: @token.id).order("frequency desc").limit(30)
    hwords = source::Token.where(id: g3_3.map(&:token2_id) + g3_3.map(&:token1_id)).each_with_object({}) {|t,h| h[t.id] = t.word}
    @g3_3 = g3_3.map {|b| ["#{hwords[b.token1_id] || '#'} #{hwords[b.token2_id] || '#'} #{w}", b.frequency] }
    
    @common_dist_0,@common_dist_1,@common_dist_0_follow, @common_dist_1_follow = [[:preceding,0],[:preceding,1],[:following,0],[:following,1]].map do |pos,dist|
      %w(definite_articles indefinite_articles nominative_pronouns prepositions).each_with_object({}) do |kind,hash|
        f,w = @token.adjacent_words(kind, pos, dist)
        if f
          hash[kind.tr("_"," ")] = [f,w] if f > 0.007
        end
      end
    end
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
    render :json => find_sentences_for_item(w).inspect + "\n"
  end
  
  def examples
    @sentences = find_sentences_for_item(params[:phrase])
  end
  
  def inspect_phrase
    p = params[:phrase]
    p.tr!(",.!?\"", " ")
    p.squeeze!(" ")
    words = [nil,*p.split,nil]
    @data = words.zip(words.each_cons(2),words.each_cons(3))[0 ... -1]
  end
  
  
  private
  
  def id_for(source, word)
    COMMON_WORDS[source] ||= {}
    x = COMMON_WORDS[source][word] and return x
    COMMON_WORDS[source][word] = source::Token.where(word: word).first.id
  end
  
  def freq_for(t1, t2, dist, source)
    x = source::Bigram.where(token1_id: t1, token2_id: t2, distance: dist)
    [x.empty? ? 0 : x.first.frequency, 0.006]
  end
  
  # If "fact 60 (gnief te)" is frequent and "fact 40 (gnief van)" is frequent and "fact 10 (ik gnief)" is infrequent , P(noun&fact) + P(~noun&~fact) is 0.900
  # If "fact 33 (gnief * si)" is frequent and "fact 23 (non * gnief)" is infrequent and "fact 6 (e gnief)" is infrequent , P(noun&fact) + P(~noun&~fact) is 0.810
  def noun?(t, source)
    tid = t.id
    fq = t.frequency
    case params[:source]
    when '05'
      [freq_for(tid, id_for(source, "si"), 1, source), freq_for(id_for(source, "non"), tid, 1, source), freq_for(id_for(source, "e"), tid, 0, source)].zip([true, false, false]).all? do |(f,median),bool|
        f.to_f / fq > median == bool
      end
    when '06'
      [freq_for(tid, id_for(source, "te"), 0, source), freq_for(tid, id_for(source, "van"), 0, source), freq_for(id_for(source, "ik"), tid, 0, source)].zip([true, true, false]).all? do |(f,median),bool|
        f.to_f / fq > median == bool
      end
    end
  end
  
  # If "fact 40 (gnief van)" is infrequent and "fact 34 (haar gnief)" is infrequent and "fact 12 (gnief het)" is frequent , P(name&fact) + P(~name&~fact) is 0.940
  # If "fact 82 (ends with letter `n`)" is frequent and "fact 3 (di * gnief)" is frequent and "fact 1 (gnief * di)" is frequent , P(name&fact) + P(~name&~fact) is 0.970
  def name?(t, source)
    tid = t.id
    fq = t.frequency
    [freq_for(tid, id_for(source, "van"), 0, source), freq_for(id_for(source, "haar"), tid, 0, source), freq_for(tid, id_for(source, "het"), 0, source)].zip([false, false, true]).all? do |(f,median),bool|
      f.to_f / fq > median == bool
    end
  end
  
  # If "fact 81 (ends with letter `s`)" is infrequent and "fact 60 (gnief te)" is infrequent and "fact 20 (gnief ze)" is frequent , P(verb&fact) + P(~verb&~fact) is 0.870
  # If "fact 81 (ends with letter `s`)" is infrequent and "fact 51 (era * gnief)" is infrequent and "fact 4 (gnief e)" is infrequent , P(verb&fact) + P(~verb&~fact) is 0.745
  def verb?(t, source)
    tid = t.id
    fq = t.frequency
    [t.word[-1] == ?s ? [fq,0.5] : [0,0.5], freq_for(tid, id_for(source, "te"), 0, source), freq_for(tid, id_for(source, "ze"), 0, source)].zip([false, false, true]).all? do |(f,median),bool|
      f.to_f / fq > median == bool
    end
  end
  
  # If "fact 69 (gnief * maar)" is frequent and "fact 17 (gnief * een)" is infrequent and "fact 14 (het gnief)" is frequent , P(adjective&fact) + P(~adjective&~fact) is 0.905
  # If "fact 49 (gnief * era)" is frequent and "fact 17 (gnief * il)" is infrequent and "fact 7 (e * gnief)" is frequent , P(adjective&fact) + P(~adjective&~fact) is 0.900
  def adjective?(t, source)
    tid = t.id
    fq = t.frequency
    [freq_for(tid, id_for(source, "maar"), 1, source), freq_for(tid, id_for(source, "een"), 1, source), freq_for(id_for(source, "het"), tid, 0, source)].zip([true, false, true]).all? do |(f,median),bool|
      f.to_f / fq > median == bool
    end
  end
  
  def find_sentences_for_item(phrase)
    words = phrase.split
    item = if words.size == 1
      words[0]
    elsif words.size == 2
      ts = words.map {|x| x == '*' ? nil : x == '#' ? 0 : token_id_for_word(x) }.compact
      if ts.size == 1
        words.delete ?*
        words.first
      else
        "0:" + ts.join(?,)
      end
    elsif words.size == 3
      ts = words.map {|x| x == '*' ? nil : x == '#' ? 0 : token_id_for_word(x) }.compact
      ts.join(?,)
    else
      ts = words.map {|x| x == '*' ? nil : x == '#' ? 0 : token_id_for_word(x) }
      raise 'not implemented'
    end
    bloom_loop(item, phrase)[0,10]
  end

  def bloom_loop(item, phrase)
    offsets = Bloom.offsets(item, BLOOM_SIZE).sort
    source = SOURCES[params[:source]]
    File.open("#{ENV['HOME']}/corpora/process/#{params[:source]}/bloom") do |file|
      page = 0
      sentences = []
      loop do
        r = offsets.all? do |i|
          file.seek(page*BLOOM_SIZE/8 + i/8)
          c = file.getc
          return sentences if c.nil?
          c.getbyte(0) & (1 << (i % 8)) != 0
        end
        if r
          source_url,seqs = source::Seq.for_id(page+1)
          seqs.grep(regexp_for_phrase(phrase)).each {|s| sentences << [source_url,s] }
        end
        return sentences if sentences.size >= 10
        page += 1
      end
    end
  end
  
  def token_id_for_word(x)
    source = SOURCES[params[:source]]
    r = source::Token.where(word: x).first
    r and return r.id
    raise x
  end
end

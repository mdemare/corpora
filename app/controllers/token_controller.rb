class TokenController < ApplicationController
  SOURCES = {"de" => S01, "fr" => S02, "es" => S03, "nl" => S04, "it" => S05, "en" => S06}
  def token
    w = params[:id]
    source = SOURCES[params[:source]]
    @token = source::Token.where(word: w).first
    unless @token
      flash[:search] = "Word #{w} not found."
      render :index
      return
    end
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
    
  end
  
end

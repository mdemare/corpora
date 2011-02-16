class TokenController < ApplicationController
  def token
    w = params[:id]
    @token = Token_01.where(word: w).first
    unless @token
      flash[:search] = "Word #{w} not found."
      render :index
      return
    end
    @twograms = @token.twograms
    @g3ss = G3_01.for_tokens([@token])
    @g3ss_reduced = @g3ss.map {|x| x[0,50] }
    wtokens = @g3ss_reduced.flatten.map {|x| [x.wtoken1_id,x.wtoken2_id,x.wtoken3_id]}.flatten.uniq
    ws = Token_01.where(id: wtokens).all
    @token_map = ws.select(&:word).inject({}) { |memo,t| memo[t.id]=t.word ; memo }
    ws = ws.reject(&:word).inject({}) {|memo,x| memo[x.id] = [x.wtoken1_id,x.wtoken2_id];memo}
    
    g2map = Token_01.where(id: ws.values.flatten - @token_map.keys).inject({}) { |memo,t| memo[t.id]=t.word ; memo }
    find_words = -> wt1,wt2 { [@token_map[wt1] || g2map[wt1],@token_map[wt2] || g2map[wt2]]}
    ws.each {|tid,(wt1,wt2)| @token_map[tid] = find_words[wt1,wt2] }
  end
  
end

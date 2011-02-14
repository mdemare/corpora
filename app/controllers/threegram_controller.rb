class ThreegramController < ApplicationController
  def index
  end
  
  def search
    q = params[:q].split
    source_id = 1 # 
    ts = q.map{|w| w != ?* && Token.for(w, source_id) }
    g3s = ThreeGram.for_tokens(ts)

    h_fq = ThreeGram.frequency_for(g3s)
    h_words = ThreeGram.tokens_for(g3s)

    @threegrams = g3s.each_with_object([]) do |g3,acc|
      acc << [h_fq[g3.id], g3.wtokens.map{|wt| ((x = h_words[wt]) && [x]) || Token.find(wt).words }.flatten.join(" "),g3.id]
    end
  end
  
  def g3
    @g3 = ThreeGram.find(params[:id])
  end
end

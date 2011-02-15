class ThreegramController < ApplicationController
  def index
  end
  
  def search
    q = params[:q].split
    q = %w(harry wollte)
    ts = q.map{|w| w != ?* && Token_01.where(word: w).first }
    g3s = G3_01.for_tokens(ts)

    h_fq = G3_01.frequency_for(g3s)
    h_words = G3_01.tokens_for(g3s)

    @threegrams = g3s.map do |g3,acc|
      [h_fq[g3.id], g3.wtokens.map{|wt| ((x = h_words[wt]) && [x]) || Token_01.find(wt).words }.flatten.join(" "),g3.id]
    end
  end
  
  def g3
    @g3 = G3_01.find(params[:id])
  end
end

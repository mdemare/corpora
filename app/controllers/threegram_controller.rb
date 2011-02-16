class ThreegramController < ApplicationController
  SOURCES = {"de" => S01, "fr" => S02}
  def index
  end
  
  def search
    source = SOURCES[params[:source]]
    q = params[:q].split
    q = %w(harry wollte)
    ts = q.map{|w| w != ?* && source::Token.where(word: w).first }
    g3s = source::G3.for_tokens(ts)

    h_fq = source::G3.frequency_for(g3s)
    h_words = source::G3.tokens_for(g3s)

    @threegrams = g3s.map do |g3,acc|
      [h_fq[g3.id], g3.wtokens.map{|wt| ((x = h_words[wt]) && [x]) || source::Token.find(wt).words }.flatten.join(" "),g3.id]
    end
  end
  
  def g3
    source = SOURCES[params[:source]]
    @g3 = source::G3.find(params[:id])
  end
end

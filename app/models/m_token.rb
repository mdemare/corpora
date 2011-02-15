# :id, "mediumint unsigned", :null => false
# :word, "varchar(255)"
# :wtoken1_id, "integer unsigned", :null => false
# :wtoken2_id, "integer unsigned", :null => false
# :frequency, "integer unsigned", :null => false
# :frequency_special, "tinyint unsigned", :null => false
module MToken
  module ClassMethods; end
  
  def self.included(klass)
    klass.extend(ClassMethods)
  end
   
  module ClassMethods
    def definite_article_tokens(position = :preceding)
      # TODO also add 3-grams with token as first or last item
#      x = @definite_article_tokens and return x
      logger.info("DEFINITE TOKENS")
      @definite_article_tokens = where(word: definite_articles)
      if position == :preceding
        @definite_article_tokens += where(wtoken2_id: @definite_article_tokens.map(&:id)).all
      end
      @definite_article_tokens.map!(&:id)
      logger.info("END DEFINITE TOKENS")
      @definite_article_tokens
    end
    
    def indefinite_article_tokens
      # TODO also add 3-grams with token as first or last item
 #     x = @indefinite_article_tokens and return x
      logger.info("INDEFINITE TOKENS")
      @indefinite_article_tokens = where(word: indefinite_articles).all
      @indefinite_article_tokens.map!(&:id)
      logger.info("END INDEFINITE TOKENS")
      @indefinite_article_tokens
    end
  end
  
  # two grams
  def words
    [word, word_for(wtoken1_id), word_for(wtoken2_id)].compact
  end
  
  def word_for(wt)
    # Apfel: 250 calls
    return nil
    wt > 0 ? self.class.find(wt).word : nil
  end
  
  def twograms
    sql = "select wtoken1_id,wtoken2_id,frequency from `tokens_#{source}` where wtoken%d_id = ?"
    [1,2].map {|i| self.class.find_by_sql([sprintf(sql,i),id]) }
  end
  
  def upper_expected_ratio
    fq = frequency_special
    upper = fq >> 4
    title = fq & 15
    expected = 15 - title - upper
    upper.to_f / 15
  end
  
  def title_expected_ratio
    fq = frequency_special
    upper = fq >> 4
    title = fq & 15
    expected = 15 - title - upper
    title.to_f / 15
  end
end
# puts "upper: #{(fqall >> 4)}"
# puts "capitalized: #{(fqall & 15)}"
# puts "expected: #{15 - (fqall & 15) - (fqall >> 4)}"


=begin
B1 = 4
B2 = (1 << B1) - 1
BTOT = (2 << 8) - 1
def est(x) a = x >> B1;a == 0 ? x & B2 : ((x & B2)+16) * 2**(a-1);end
def inc(x)
  return x if x == BTOT
  a = x >> B1
  
  if a < 2 or rand(2**(a-1)) == 0
    if x & B2 == B2
      (a + 1) << B1
    else
      x + 1
    end 
  else
    x
  end
end
(1..10).map{x=0;(0..999).map{x=inc(x)};x}.sort
x=[0,0,0];while x[2]<64;inc(x);end;x[2];a,b,c = *x;puts "real: #{c}","estimated: #{a == 0 ? b : (b+16) * 2**(a-1)}"
=end

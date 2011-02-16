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
    def adjacent_words(token, kind, position)
      list, token_list = adjacent_tokens(kind, position)
      args = [list,[token.id],nil]
      args.reverse! if position == :following
      
      g3_sum = G3_01.tokens(*args).inject(0) {|sum,x| sum+x.frequency}
      
      # where both are part of 2-gram
      column1 = position == :preceding ? :wtoken2_id : :wtoken1_id
      column2 = position != :preceding ? :wtoken2_id : :wtoken1_id
      where(column1 => token.id, column2 => token_list).inject(g3_sum) {|sum,x|sum+x.frequency}
    end

    # e.g. pronouns, preceding:
    # ich /token/
    # du /token/
    # but also
    # <*, ich> /token/
    # and
    # <ich /token/>
    def adjacent_tokens(kind, position)
      ia = ((@cache ||= {})[kind] ||= {})
      r = ia[position] and return r
      
      # word tokens for kind
      token_list = where(word: send(kind)).map(&:id)
      
      column = position == :preceding ? :wtoken2_id : :wtoken1_id
      # when word in list is part of 2-gram
      rvalue = token_list + where(column => token_list).map(&:id)
      
      ia[position] = [rvalue,token_list]
    end
  end
  
  # two grams
  def words
    [word, word_for(wtoken1_id), word_for(wtoken2_id)].compact
  end
  
  def word
    w = attributes["word"]
    w ? w.force_encoding("utf-8") : nil
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

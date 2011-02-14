# t.column :id, "bigint", :null => false
# t.string :word
# t.column :wtoken1_id, "bigint"
# t.column :wtoken2_id, "bigint"
# t.column :frequency, "bigint", :null => false
class Token < ActiveRecord::Base
  def Token.for(word, source_id)
    t = where(word: word, source_id: source_id)
    t[0]
  end
  
  # two grams
  def words
    if word
      [word]
    else
      [wtoken1_id && class.find(wtoken1_id).word, wtoken2_id && class.find(wtoken2_id).word].compact
    end
  end
end

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
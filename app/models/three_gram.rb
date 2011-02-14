# t.column :id, "bigint", :null => false
# t.column :wtoken1_id, "bigint", :null => false
# t.column :wtoken2_id, "bigint", :null => false
# t.column :wtoken3_id, "bigint", :null => false

# sequences
# t.column :three_gram_id, "bigint", :null => false
# t.column :sequence, "bigint", :null => false


module MThreeGram
  module ClassMethods; end
  
  def self.included(klass)
    klass.extend(ClassMethods)
  end
   
  module ClassMethods
    def for_tokens(tokens)
      (1..3).each_cons(tokens.size).with_object([]) do |token_index_range,acc|
        conditions = token_index_range.each.with_object({}).with_index do |(token_index,conditions),j|
          conditions["wtoken#{token_index}_id".to_sym] = tokens[j].id if tokens[j]
        end
        where(conditions).each {|g3| acc << g3 }
      end
    end
  
    def frequency_for(g3s)
      return {} if g3s.empty?
      sql = "SELECT three_gram_id,count(*) freq FROM `sequences_three_grams` WHERE `sequences_three_grams`.three_gram_id IN (#{g3s.map(&:id).join(?,)}) GROUP BY `sequences_three_grams`.three_gram_id"
      find_by_sql(sql).each_with_object({}) {|g3,memo| memo[g3.three_gram_id] = g3.freq}
    end
  
    def tokens_for(g3s)
      return {} if g3s.empty?
      token_ids = g3s.map{|g3| [g3.wtoken1_id,g3.wtoken2_id,g3.wtoken3_id,]}.flatten.sort.uniq
      sql = "SELECT id,word FROM `tokens` WHERE `tokens`.id IN (#{token_ids.join(?,)})"
      find_by_sql(sql).each_with_object({}) {|t,memo| memo[t.id] = t.word}
    end
  end
  
  def seqs
    Sequence.for_3gram(id)
  end
  
  def wtokens
    [wtoken1_id,wtoken2_id,wtoken3_id,]
  end
  
  def words
    [wtoken1_id,wtoken2_id,wtoken3_id].map { |t| Token.find(t).words }.flatten
  end
  
  def frequency
    sql = "SELECT count(*) freq FROM `sequences_three_grams` WHERE (`sequences_three_grams`.three_gram_id = ? )"
    class.find_by_sql([sql, id]).first.freq.to_i
  end
  
class ThreeGram < ActiveRecord::Base
  include MThreeGram
end

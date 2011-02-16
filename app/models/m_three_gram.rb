module MThreeGram
  module ClassMethods; end
  
  def self.included(klass)
    klass.extend(ClassMethods)
    klass.instance_eval do
      set_table_name "g3_#{source}"
    end
  end
   
  module ClassMethods
    def for_tokens(tokens)
      (1..3).each_cons(tokens.size).with_object([]) do |token_index_range,acc|
        conditions = token_index_range.each.with_object({}).with_index do |(token_index,conditions),j|
          conditions["wtoken#{token_index}_id".to_sym] = tokens[j].id if tokens[j]
        end
        acc << where(conditions)
      end
    end
  
    def tokens(*token_positions)
      c = token_positions.each.with_object({}).with_index do |(ts,conditions),i|
        if ts
          conditions["wtoken#{i+1}_id".to_sym] = ts
        end
      end
      where(c)
    end
  
    def frequency_for(g3s)
      return {} if g3s.empty?
      sql = "SELECT three_gram_id,count(*) freq FROM `s3g_#{source}` WHERE three_gram_id IN (#{g3s.map(&:id).join(?,)}) GROUP BY three_gram_id"
      find_by_sql(sql).each_with_object({}) {|g3,memo| memo[g3.three_gram_id] = g3.freq}
    end
  
    def tokens_for(g3s)
      return {} if g3s.empty?
      token_ids = g3s.map{|g3| [g3.wtoken1_id,g3.wtoken2_id,g3.wtoken3_id,]}.flatten.sort.uniq
      sql = "SELECT id,word FROM `tokens_#{source}` WHERE id IN (#{token_ids.join(?,)})"
      find_by_sql(sql).each_with_object({}) {|t,memo| memo[t.id] = t.word}
    end
  end
  
  def seqs
    sequence_class.for_3gram(id)
  end
  
  def wtokens
    [wtoken1_id,wtoken2_id,wtoken3_id,]
  end
  
  def words(tmap = {})
    [wtoken1_id,wtoken2_id,wtoken3_id].map { |t| tmap[t] || token_class.find(t).words }.flatten.compact
  end
end

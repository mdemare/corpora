module MSequence
  module ClassMethods; end
  
  def self.included(klass)
    klass.extend(ClassMethods)
    klass.instance_eval do
      set_table_name "seq_#{source}"
    end
  end
   
  module ClassMethods
    def for_3gram(g3_id)
      sql = <<-SQL
        SELECT `s3g_#{source}`.sequence,UNCOMPRESS(`seq_#{source}`.compressed_sentences) sentence FROM `seq_#{source}` 
        INNER JOIN `s3g_#{source}` 
        ON `seq_#{source}`.id = `s3g_#{source}`.sequence div 100
        WHERE (`s3g_#{source}`.three_gram_id = ? )
      SQL

      find_by_sql([sql, g3_id]).map do |s|
        s.sentence.split('/')[s.sequence % 100].force_encoding("UTF-8")
      end
    end
    
    def for_id(seq_id)
      sql = "SELECT id,UNCOMPRESS(compressed_sentences) sentence FROM `seq_#{source}` WHERE id = ? LIMIT 1"
      find_by_sql([sql, seq_id]).first.sentence.force_encoding("UTF-8").split('/')
    end
  end
end


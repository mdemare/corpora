module MSequence
  module ClassMethods; end
  
  def self.included(klass)
    klass.extend(ClassMethods)
  end
   
  module ClassMethods
    BASE62 = [*'0'..'9']+[*'a'..'z']+[*'A'..'Z']
    RBASE62 = Hash[*BASE62.zip(0..62).flatten]
    def from_62(n)
      n && !n.empty? && n != "#" or return nil
      (1..n.size).inject(0) do |acc,i|
        acc += RBASE62[n[-i]] * 62 ** (i-1)
      end
    end

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
    
    def for_id(seq_id,offset)
      sql = "SELECT id,UNCOMPRESS(compressed_sentences) sentence FROM `seq_#{source}` WHERE id = ?"
      find_by_sql([sql, seq_id]).first.sentence.split('/')[offset % 100].force_encoding("UTF-8")
    end
  end
end


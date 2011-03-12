module MSequence
  module ClassMethods; end
  
  def self.included(klass)
    klass.extend(ClassMethods)
    klass.instance_eval do
      set_table_name "seq_#{source}"
    end
  end
   
  module ClassMethods
    def for_id(seq_id)
      sql = "SELECT id,source src,UNCOMPRESS(compressed_sentences) sentence FROM `seq_#{source}` WHERE id = ? LIMIT 1"
      seq = find_by_sql([sql, seq_id]).first
      ["http://www.fanfiction.net/s/#{seq.src.tr('-','/')}",seq.sentence.force_encoding("UTF-8").split('/')]
    end
  end
end


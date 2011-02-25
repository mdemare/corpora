module MBigram
  module ClassMethods; end
  
  def self.included(klass)
    klass.extend(ClassMethods)
    klass.instance_eval do
      set_table_name "bigrams_#{source}"
    end
  end
   
  module ClassMethods
  end
end

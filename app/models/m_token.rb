# create new files:
# for i in {1..6}; do echo $'module S0'$i$'\n  class Bigram < Base\n    include MBigram\n  end\nend\n' > s0$i/bigram.rb; done
# for i in {1..6}; do echo $'module S0'$i$'\n  class Trigram < Base\n    include MTrigram\n  end\nend\n' > s0$i/trigram.rb; done

$token_cache = {}

module MToken
  module ClassMethods; end
  
  def self.included(klass)
    klass.extend(ClassMethods)
    klass.instance_eval do
      set_table_name "tokens_#{source}"
    end
  end
  
  def adjacent_words(kind, position = :preceding, dist = 0)
    token_hash = adjacent_tokens(kind) or raise
  
    # where both are part of 2-gram
    column1 = position == :preceding ? :token2_id : :token1_id
    column2 = position != :preceding ? :token2_id : :token1_id
    g2s = self.g2_class.where(column1 => self.id, column2 => token_hash.map(&:first), :distance => dist).all
    p_kind_token = g2s.inject(0.0) {|sum,x|sum+x.frequency} / self.frequency
    if g2s.empty?
      return nil
    end
    
    most_common_of_kind = g2s.map do |g2|
      raise unless g2
      gid = g2.send(column2)
      th = token_hash[gid] or raise gid 
      [g2.frequency / th[1].to_f, th[0]]
    end.sort_by(&:first).last[1]
    raise unless p_kind_token
    raise unless most_common_of_kind
    [p_kind_token, most_common_of_kind]
  end
  
  def adjacent_tokens(kind)
    ia = ($token_cache[source] ||= {})[kind] and return ia
  
    # word tokens for kind
    token_hash = self.class.where(word: self.class.send(kind)).each_with_object({}) {|x,h| h[x.id] = [x.word,x.frequency] }
    $token_cache[source][kind] = token_hash
  end
  
  def word
    w = attributes["word"]
    w ? w.force_encoding("utf-8") : nil
  end
   
  module ClassMethods
  end
end

# t.column :id, "bigint", :null => false
# t.binary :compressed_sentences, :null => false

# three-grams
# t.column :three_gram_id, "bigint", :null => false
# t.column :sequence, "bigint", :null => false
class Sequence < ActiveRecord::Base
  set_primary_key :sequence
  
  BASE62 = [*'0'..'9']+[*'a'..'z']+[*'A'..'Z']
  RBASE62 = Hash[*BASE62.zip(0..62).flatten]
  def Sequence.from_62(n)
    n && !n.empty? && n != "#" or return nil
    (1..n.size).inject(0) do |acc,i|
      acc += RBASE62[n[-i]] * 62 ** (i-1)
    end
  end
  
  def Sequence.for_3gram(g3_id)
    sql = <<-SQL
    SELECT `sequences_three_grams`.sequence,UNCOMPRESS(`sequences`.compressed_sentences) sentence FROM `sequences` 
    INNER JOIN `sequences_three_grams` 
    ON `sequences`.id = `sequences_three_grams`.sequence + 1 - (`sequences_three_grams`.sequence % 1000000000) + (`sequences_three_grams`.sequence % 1000000000) div 100 
    WHERE (`sequences_three_grams`.three_gram_id = ? )
    SQL
    find_by_sql([sql, g3_id]).map do |s|
      offset = s.sequence % 100
      # [s.sequence, s.sentence.split('/')[offset]]
      s.sentence.split('/')[offset].force_encoding("UTF-8")
    end
  end
  # 
  # def render
  #   tokens.force_encoding("UTF-8").split(",").map do |x| 
  #     case
  #     when x[0] == ?"
  #       x[1...-1]
  #     when x == ?#
  #       ""
  #     else
  #       tid = Sequence.from_62(x)
  #       t = Token.where(token: tid, source_id: source_id).first
  #       if t.word
  #         t.word
  #       else
  #         TwoGram.where(g2: t.g2).first.words.join(" ")
  #       end
  #     end
  #   end.join(" ")
  # rescue
  #   raise sequence.to_s
  # end
  # 
end

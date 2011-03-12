require "unicode_utils"

module TokenHelper
  def link_to_token(word)
    if word.blank?
      ""
    else
      w = UnicodeUtils.downcase(word)
      link_to w, token_url(id: w)
    end
  end
  
  def link_to_example(tokens)
    if tokens.nil?
      ""
    else
      p = UnicodeUtils.downcase(tokens.map {|x| x.nil? ? "#" : x}.join(" "))
      link_to p, examples_url(phrase: p)
    end
  end

  

end

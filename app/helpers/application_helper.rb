module ApplicationHelper
  def likelihood(ratio, normal, kind)
    case ratio / normal
    when 0 ... 0.4
      "It is very unlikely to be #{kind}."
    when 0.4 ... 0.8
      "It is unlikely to be #{kind}."
    when 0.8 ... 1.2
      "It might be be #{kind}."
    when 1.2 ... 1.6
      "It is likely to be #{kind}."
    when 1.6 ... 2.4
      "It is very likely to be #{kind}."
    else
      "It is extremely likely to be #{kind}."
    end
  end
  
  def regexp_for_phrase(phrase)
    words = phrase.split
    ends_with_period = false
    pieces = words.map.with_index do |w,i|
      case w
      when "#"
        ends_with_period = true if i > 0
        nil
      when "*"
        "\\w+"
      else
        w
      end
    end
    r = pieces.compact.join("\\W+") + (ends_with_period ? "[.]" : "")
    %r(#{r})i
  end
end

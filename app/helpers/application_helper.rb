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
end

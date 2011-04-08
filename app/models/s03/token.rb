# encoding: utf-8
module S03
  class Token < Base
    include MToken
  
    def self.definite_articles
      %w(el la los las)
    end
  
    def self.indefinite_articles
      %w(un una unos unas)
    end
  
    def self.nominative_pronouns
      %w(yo tu tú él ella nosotros vosotros ellos ellas usted ustedes)
    end
  
    def self.prepositions
      %w(a al bajo como con contra de del desde durante en entre hacia hasta para por según sin sobre tras)
    end
  
    def self.negations
      %w(no)
    end
  end
end
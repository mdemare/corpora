# encoding: utf-8
module S01
  class Token < Base
    include MToken
  
    def self.definite_articles
      %w(der die das des dem den)
    end
  
    def self.indefinite_articles
      %w(ein eine einer eines einen einem)
    end
  
    def self.nominative_pronouns
      %w(ich du er es sie wir ihr)
    end
  
    def self.prepositions
      %w(an auf aus außer bei bis durch entlang für gegen hinter in mit nach neben ohne seit trotz unter über um von vor während wegen zu zwischen)
    end
  end
end
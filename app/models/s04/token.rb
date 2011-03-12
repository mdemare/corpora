# encoding: utf-8
module S04
  class Token < Base
    include MToken
  
    def self.definite_articles
      %w(the)
    end
  
    def self.indefinite_articles
      %w(a an)
    end
  
    def self.nominative_pronouns
      %w(i you he she it we they)
    end
  
    def self.prepositions
      %w(about above across after against along among around at before behind below beneath beside between beyond by despite down during except for from in inside into like minus near of off on onto opposite outside over past per plus regarding round since than through to toward under underneath unlike until up upon versus via with within without)
    end
  end
end
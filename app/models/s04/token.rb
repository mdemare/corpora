# encoding: utf-8
module S04
  class Token < Base
    include MToken
  
    def self.definite_articles
      %w(le la l' les)
    end
  
    def self.indefinite_articles
      %w(un une du des)
    end
  
    def self.nominative_pronouns
      %w(je j' tu il elle nous vous ils elles)
    end
  
    def self.prepositions
      %w(sur jusqu'à' pour contre hinter à en dans avec après sans par de entre)
    end

    def self.negations
      %w(ne n')
    end
  end
end

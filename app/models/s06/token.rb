# encoding: utf-8
module S06
  class Token < Base
    include MToken
  
    def self.definite_articles
      %w(de het)
    end
  
    def self.indefinite_articles
      %w(een)
    end
  
    def self.nominative_pronouns
      %w(ik jij je hij zij ze het wij we jullie)
    end
  
    def self.prepositions
      %w(aan achter behalve beneden bij binnen boven buiten circa contra dankzij door gedurende in langs met middels na naar naast nabij namens om omstreeks omtrent ondanks onder op over per rond rondom sedert sinds te tegen tegenover ten ter tijdens tot tussen uit van vanaf vanuit vanwege versus via volgens voor voorbij wegens zonder)
    end

    def self.negations
      %w(niet)
    end
  end
end
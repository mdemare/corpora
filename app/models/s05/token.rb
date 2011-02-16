# encoding: utf-8
module S05
  class Token < Base
    include MToken
  
    def self.definite_articles
      %w(il lo gli la i le)
    end
  
    def self.indefinite_articles
      %w(un una uno)
    end
  
    def self.nominative_pronouns
      %w(io tu lei lui esso essa noi voi loro essi esse)
    end
  
    def self.prepositions
      %w(a accanto ad adosso appo assieme attorno attraverso avanti collo contra contro da dal dalli davanti dentro di dietro dopo durante eccetto entro extra fino fra fuori in innanzi insieme insino intorno invece malgrado meco mediante oltra oltre per più presso pro rasente salvo seco secondo senz' senza sino sopra sott' sotto sovra stante su teco tolto tra tramite tranne verso versus)
    end
  end
end
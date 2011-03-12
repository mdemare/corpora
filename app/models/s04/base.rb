# encoding: utf-8
module S04
  class Base < ActiveRecord::Base
    def token_class; Token end
    def sequence_class; Seq end
    def g2_class; Bigram end
    def g3_class; Trigram end
    def source; "04" ; end
    def self.source; "04" ; end
  end
end
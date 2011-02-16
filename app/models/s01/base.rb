# encoding: utf-8
module S01
  class Base < ActiveRecord::Base
    def token_class; Token end
    def sequence_class; Seq end
    def g3_class; G3 end
    def source; "01" ; end
    def self.source; "01" ; end
  end
end
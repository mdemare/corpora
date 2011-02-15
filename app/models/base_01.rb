class Base_01 < ActiveRecord::Base
  def token_class; Token_01 end
  def sequence_class; Seq_01 end
  def source; "01" ; end
  def self.source; "01" ; end
end
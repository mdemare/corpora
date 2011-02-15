class Token_01 < Base_01
  set_table_name "tokens_01"
  include MToken
  
  def self.definite_articles
    %w(der die das des dem den)
  end
  
  def self.indefinite_articles
    %w(ein eine einer eines einen einem)
  end
end


class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true
  

  def self.switch_connection(database_name)
    self.establish_connection("sqlserver://TUENLACETV:1234@localhost:62452/#{database_name}?mode=dblib")
  end
  
end

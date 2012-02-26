class Eqvaccine
  include Mongoid::Document
  
  field :targetcon, :type => String     #target condition
  field :vaccine, :type => String    #vaccine product name
  field :order, :type => Integer
  field :date, :type => String
  field :clinic, :type => String

  embedded_in :eqcondition, :inverse_of => :eqvaccines

end

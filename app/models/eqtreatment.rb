class Eqtreatment
  include Mongoid::Document
  field :medname, :type => String
  field :start, :type => String
  field :end, :type => String
  field :note, :type => String

  embedded_in :eqcondition, :inverse_of => :eqtreatments

end

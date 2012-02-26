class Hbv
  include Mongoid::Document

  field :igm_anti_hav, :type => Boolean

  belongs_to :eqcondition
end

class Eqtest
  include Mongoid::Document
  field :date, :type => String
  field :afp, :type => String
  field :ct, :type => Boolean
  field :ultrasound, :type => Boolean
  field :alt, :type => String
  field :hbv_dna, :type => String
  field :other, :type => String

  embedded_in :hbv, :inverse_of => :eqtests
  embedded_in :hcv, :inverse_of => :eqtests

end

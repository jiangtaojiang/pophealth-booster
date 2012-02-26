class Patient
  include Mongoid::Document
  field :firstname, :type => String
  field :lastname, :type => String
  field :member_id, :type => String, :unique => true

  validates_presence_of :firstname, :lastname
  validates_uniqueness_of :member_id

  has_one :profile, :dependent => :delete

  #generic conditions
  has_many :eqconditions,  :dependent => :delete

  #meet guideline or not for a equity measure
  field :eqmeasure_meet_gl, :type => Boolean

end

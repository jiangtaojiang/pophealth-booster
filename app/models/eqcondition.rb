#generic condition for equity measure
class Eqcondition
  include Mongoid::Document

  field :code, :type => String,  :presence => true
  field :name, :type => String,  :presence => true

  #test interpretation
  field :test_status, :type => String, default: TEST_STATUS_UNTESTED
  field :alert_test, :type => String

  embeds_many :eqvaccines
  field :alert_vaccine, :type => String

  embeds_many :eqtreatments
  field :alert_treatment, :type => String

  field :alert_monitor, :type => String

  #specific condition, only one of the following conditions will be created
  has_one :hbv, :dependent => :delete
  has_one :hcv, :dependent => :delete

  belongs_to :patient

end

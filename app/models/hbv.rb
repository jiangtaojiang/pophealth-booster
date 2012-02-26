class Hbv
  include Mongoid::Document

  #test results
  field :hbs_ag_pos, :type => Boolean
  field :hbs_ag_neg, :type => Boolean
  field :hbs_ag_date, :type => String

  field :anti_hbs_pos, :type => Boolean
  field :anti_hbs_neg, :type => Boolean
  field :anti_hbs_date, :type => String

  field :anti_hbc_pos, :type => Boolean
  field :anti_hbc_neg, :type => Boolean
  field :anti_hbc_date, :type => String

  field :igm_anti_hbc_pos, :type => Boolean
  field :igm_anti_hbc_neg, :type => Boolean
  field :igm_anti_hbc_date, :type => String

  #test interpretation
  #field :test_status, :type => String
  #field :alert_test, :type => String

  embeds_many :eqtests
  #field :alert_monitor, :type => String

  belongs_to :eqcondition


end

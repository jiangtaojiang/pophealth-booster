class Hcv
  include Mongoid::Document

  #test results
  field :anti_hcv_pos, :type => Boolean
  field :anti_hcv_neg, :type => Boolean
  field :anti_hcv_dadte, :type => String

  field :hcv_riba_pos, :type => Boolean
  field :hcv_riba_neg, :type => Boolean
  field :hcv_riba_date, :type => String

  field :hcv_rna_pos, :type => Boolean
  field :hcv_rna_neg, :type => Boolean
  field :hcv_rna_date, :type => String

  #test interpretation
  #field :test_status, :type => String
  #field :alert_test, :type => String

  embeds_many :eqtests
  #field :alert_monitor, :type => String

  belongs_to :eqcondition

end

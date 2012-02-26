class Equity
  include Mongoid::Document

  field :measure_code, :type => String
  field :condition_code, :type => String
  field :measure_name, :type => String
  field :expected_count, :type => Integer, default: 0
  field :actual_count, :type => Integer, default: 0
  field :percentage, :type => Float, default: 0


end

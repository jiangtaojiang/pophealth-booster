class Guideline
  include Mongoid::Document

  field :gn, :type => Integer
  field :cause, :type => String
  field :test_rec, :type => String
  #field :test_needed, :type => Boolean, default: true
  field :treat_rec, :type => String
  field :vaccine_needed, :type => Boolean, default: false

end
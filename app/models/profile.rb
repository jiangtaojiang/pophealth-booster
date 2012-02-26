class Profile
  include Mongoid::Document

  #personal
  field :gender, :type => String
  field :birthday, :type => String  #Date
  field :country_born, :type => String
  field :race, :type => String

  field :pregnant, :type => Boolean

  field :close_contacts_hbv, :type => Boolean
  field :injection_drug_user, :type => Boolean
  field :gay_man, :type => Boolean

  #family
  field :mother_country_born, :type => String
  field :father_country_born, :type => String
  field :mother_hbv, :type => Boolean
  field :mother_hcv, :type => Boolean

  #medical eqconditions
  field :immunosuppressive, :type => Boolean
  field :hemodialysis, :type => Boolean
  field :exposed_infected_blood_organ, :type => Boolean
  field :med_donor, :type => Boolean

  #liver
  field :clot_factor_1987, :type => Boolean
  field :blood_organ_1992, :type => Boolean
  field :elevated_liver_enzymes, :type => Boolean
  #field :liver_disease, :type => Boolean
  field :hbv_cared, :type => Boolean
  field :hbv_risk_gns, :type => Array  # auto-determined guideline numbers
  field :hcv_positive, :type => Boolean
  field :hcv_risk_gns, :type => Array  # auto-determined guideline number

  field :hiv_positive, :type => Boolean

  belongs_to :patient

end

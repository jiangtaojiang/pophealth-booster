module ProfilesHelper

  #check patient profile for risk factors, set risk guideline numbers
  def check_risks(profile)
    check_hbv_risk(profile)
    check_hcv_risk(profile)
  end

end

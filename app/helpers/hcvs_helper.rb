module HcvsHelper

  #CDC hcv risk guideline, number => guideline
  @@hcv_guidelines = {
    1 => Guideline.new(:gn => 1,
      :cause =>"Persons who currently inject drugs or who have injected drugs in the past, even if once or many years ago.",
      :test_rec => "Testing for chronic infection. ",
      :treat_rec => "",
      :vaccine_needed => false
    ),
    2 => Guideline.new(:gn => 2,
      :cause =>"Recipients of clotting factor concentrates before 1987.",
      :test_rec => "Testing for chronic infection.",
      :treat_rec => "",
      :vaccine_needed => false
    ),
    3 => Guideline.new(:gn => 3,
      :cause =>"Recipients of blood transfusions or donated organs before July 1992.",
      :test_rec => "Testing for chronic infection.",
      :treat_rec => "",
      :vaccine_needed => false
    ),
    4 => Guideline.new(:gn => 4,
      :cause =>"Long-term hemodialysis patients.",
      :test_rec => "Testing for chronic infection.",
      :treat_rec => "",
      :vaccine_needed => false
    ),
    5 => Guideline.new(:gn => 5,
      :cause =>"Persons with known exposures to HCV (e.g., healthcare workers after needlesticks, recipients of blood or organs from a donor who later tested positive for HCV).",
      :test_rec => "Testing for chronic infection.",
      :treat_rec => "",
      :vaccine_needed => false
    ),
    6 => Guideline.new(:gn => 6,
      :cause =>"HIV-infected persons.",
      :test_rec => "Testing for chronic infection.",
      :treat_rec => "",
      :vaccine_needed => false
    ),
    7 => Guideline.new(:gn => 7,
      :cause =>"Children born to infected mothers (do not test before age 18 mos.)",
      :test_rec => "Testing for chronic infection.",
      :treat_rec => "",
      :vaccine_needed => false
    ),
    8 => Guideline.new(:gn => 8,
      :cause =>"Patients with signs or symptoms of liver disease (e.g., abnormal liver enzyme tests).",
      :test_rec => "Testing for chronic infection.",
      :treat_rec => "",
      :vaccine_needed => false
    ),
    9 => Guideline.new(:gn => 9,
      :cause =>"Donors of blood, plasma, organs, tissues, or semen.",
      :test_rec => "Testing for chronic infection.",
      :treat_rec => "",
      :vaccine_needed => false
    ),
  }


  #check patient profile for risk factors
  #set array of guideline numbers to profile
  def check_hcv_risk(profile)
    #order important, highest risk (requiring treatment) should go first
    gns = []
    if profile.hiv_positive
      gns.push(6)
    end
    if profile.injection_drug_user
      gns.push(1)
    end
    if profile.clot_factor_1987
      gns.push(2)
    end
    if profile.blood_organ_1992
      gns.push(3)
    end
    if profile.hemodialysis
      gns.push(4)
    end
    if profile.exposed_infected_blood_organ
      gns.push(5)
    end
    if profile.mother_hcv
      gns.push(7)
    end
    if profile.elevated_liver_enzymes
      gns.push(8)
    end
    if profile.med_donor
      gns.push(9)
    end
    profile.update_attributes(:hcv_risk_gns => gns)
  end

  #is patient at risk for HCV
  def at_risk_hcv(profile)
    return profile.hcv_risk_gns != nil && profile.hcv_risk_gns.length > 0
  end

  #return risk alert
  def show_hcv_risk_alert(profile)
    if at_risk_hcv(profile) && !profile.hcv_positive
      return "Check HCV condition for actions!"
    else
      return ""
    end
  end

  #get risk guidelines based on profile
  def get_hcv_guidelines(profile)
    gs = []
    if(profile.hcv_risk_gns)
      profile.hcv_risk_gns.each do |gn|
        gs.push(@@hcv_guidelines[gn])
      end
    end
    return gs
  end

  #interprete hcv test results, set status
  def interpret_hcv_test_result(hcv)
    status = TEST_STATUS_UNTESTED
    if hcv.anti_hcv_pos
      if hcv.hcv_riba_pos || hcv.hcv_rna_pos
        status = TEST_STATUS_INFECTED
      elsif hcv.hcv_riba_neg
        status = TEST_STATUS_NOT_INFECTED
      end
    elsif hcv.anti_hcv_neg
      status = TEST_STATUS_NOT_INFECTED
    end
    return status
  end

  #determine alert based on rsk and status
  def determine_hcv_test_alert(profile, test_status)
    alert = nil
    atrisk = at_risk_hcv(profile)
    if(atrisk && test_status == TEST_STATUS_UNTESTED)
      alert = "Go get testing."
    elsif (test_status == TEST_STATUS_INFECTED_ACUTE)
      alert = "Get antivirals and supportive treatment."
    elsif (test_status == TEST_STATUS_INFECTED)
      alert = "Start regular monitoring for liver disease; Get treated with antiviral drugs if needed."
    end
    return alert
  end

  #if monitoring is needed but not get it, return alert
  def determine_hcv_monitoring_alert(hcv, test_status)
    if(hcv.eqtests == nil || hcv.eqtests.length == 0)  #no test done
      if(test_status == TEST_STATUS_INFECTED )  #need monitoring
         return "You should start regular monitoring for liver cancer and liver damage!"
      end
    end
  end

  #if treatment is needed but not get it, return alert
  def determine_hcv_treatment_alert(eqcondition, test_status)
    if(eqcondition.eqtreatments.length == 0)  #no test done
      if(test_status == TEST_STATUS_INFECTED )  #need monitoring
         return "You should check if early treatment is needed now!"
      end
    end
  end

end

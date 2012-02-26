module HbvsHelper

  #CONSTANT ?

  #countries with HBsAg prevalence >2%
  #@@hbv_2pcnt_countries = {
    #'CN' => '1'
  #}

  #countries HBsAg prevalence >8%
  #@@hbv_8pcnt_countries = {
    #'CN' => '1'
  #}

  #CDC hbv risk guideline, number => guideline
  @@hbv_guidelines = {
    1 => Guideline.new(:gn => 1,
      :cause =>"Persons born in regions of high and intermediate HBV endemicity (HBsAg prevalence 2%).",
      :test_rec => "Test for HBsAg, regardless of vaccination status in their country of origin.",
      :treat_rec => "If HBsAg-positive, refer for medical management. If negative, assess for on-going risk for hepatitis B and vaccinate if indicated.",
      :vaccine_needed => false
    ),
    2 => Guideline.new(:gn => 2,
      :cause => "US born persons not vaccinated as infants whose parents were born in regions with high HBV endemicity ( 8%).",
      :test_rec => "Test for HBsAg regardless of maternal HBsAg status if not vaccinated as infants in the United States.",
      :treat_rec => "If HBsAg-positive, refer for medical management. If negative, assess for on-going risk for hepatitis B and vaccinate if indicated.",
      :vaccine_needed => false
    ),
    3 => Guideline.new(:gn => 3,
      :cause => "Injection-drug users",
      :test_rec => "Test for HBsAg, as well as for anti-HBc or anti-HBs to identify susceptible persons.",
      :treat_rec => "First vaccine dose should be given at the same visit as testing. Susceptible persons should complete a 3-dose hepatitis B vaccine series to prevent infection from ongoing exposure.",
      :vaccine_needed => true
    ),
    4 => Guideline.new(:gn => 4,
      :cause => "Men who have sex with men",
      :test_rec => "Test for HBsAg, as well as for anti-HBc or anti-HBs to identify susceptible persons.",
      :treat_rec => "First vaccine dose should be given at the same visit as testing. Susceptible persons should complete a 3-dose hepatitis B vaccine series to prevent infection from ongoing exposure.",
      :vaccine_needed => true
    ),
    5 => Guideline.new(:gn => 5,
      :cause => "Persons needing immunosuppressive therapy, including chemotherapy, immunosuppression related to organ transplantation, and immunosuppression for rheumatologic or gastroenterologic disorders",
      :test_rec => "Test for all markers of HBV infection (HBsAg, anti-HBc, and anti-HBs).",
      :treat_rec => "Treat persons who are HBsAg-positive. Monitor closely persons who are anti-HBc positive for signs of liver disease.",
      :vaccine_needed => false
    ),
    6 => Guideline.new(:gn => 6,
      :cause => "Persons with elevated ALT/AST of unknown etiology.",
      :test_rec => "Test for HBsAg along with other appropriate medical evaluation.",
      :treat_rec => "Follow-up as indicated.",
      :vaccine_needed => false
    ),
    7 => Guideline.new(:gn => 7,
      :cause => "Donors of blood, plasma, organs, tissues, or semen.",
      :test_rec => "Test for HBsAg, anti-HBc, and HBV-DNA as required.",
      :treat_rec => "",
      :vaccine_needed => false
    ),
    8 => Guideline.new(:gn => 8,
      :cause => "Hemodialysis patients.",
      :test_rec => "Test for all markers of HBV infection (HBsAg, anti-HBc, and anti-HBs). Test vaccine nonresponders monthly for HBsAg. HBsAg-positive hemodialysis patients should be cohorted.",
      :treat_rec => "Vaccinate against hepatitis B to prevent transmission and revaccinate when serum anti-HBs titer falls below 10mIU/mL.",
      :vaccine_needed => true
    ),
    9 => Guideline.new(:gn => 9,
      :cause => "All pregnant women.",
      :test_rec => "Test for HBsAg during each pregnancy, preferably in the first trimester. Test at the time of admission for delivery if prenatal HBsAg test result is not available or if mother was at risk for infection during pregnancy.",
      :treat_rec => "If HBsAg-positive, refer for medical management. To prevent perinatal transmission, infants of HBsAg-positive mothers and unknown HBsAg status mothers should receive vaccination and postexposure immunoprophylaxis in accordance with recommendations and within 12 hours of delivery.",
      :vaccine_needed => false
    ),
    10 => Guideline.new(:gn => 10,
      :cause => "Infants born to HBsAg-positive mothers",
      :test_rec => "Test for HBsAg and anti-HBs 1-2 months after completion of at least 3 doses of a licensed hepatitis B vaccine series (i.e., at age 9-18 months, generally at the next well-child visit to assess effectiveness of postexposure immunoprophylaxis). Testing should not be performed before age 9 months or within 1 month of the most recent vaccine dose.",
      :treat_rec => "Vaccinate in accordance with recommendations.",
      :vaccine_needed => false
    ),
    11 => Guideline.new(:gn => 11,
      :cause => "Household, needle-sharing, or sex contacts of persons known to be HBsAg positive",
      :test_rec => "Test for HBsAg, as well as anti-HBc or anti-HBs to identify susceptible persons.",
      :treat_rec => "First vaccine dose should be given at the same visit as testing. Susceptible persons should complete a 3-dose hepatitis B vaccine series to prevent transmission from ongoing exposure.",
      :vaccine_needed => true
    ),
    12 => Guideline.new(:gn => 12,
      :cause => "Persons who are the sources of blood or body fluids resulting in an exposure (e.g., needlestick, sexual assault) that might require postexposure prophylaxis",
      :test_rec => "Test source for HBsAg.",
      :treat_rec => "Vaccinate healthcare and public safety workers with reasonably anticipated occupational exposures to blood or infectious body fluids. Provide postexposure prophylaxis to exposed person if needed.",
      :vaccine_needed => false
    ),
    13 => Guideline.new(:gn => 13,
      :cause => "HIV-positive persons",
      :test_rec => "Test for HBsAg, as well as for anti-HBc or anti-HBs to identify susceptible persons.",
      :treat_rec => "Vaccinate susceptible persons against hepatitis B to prevent transmission.",
      :vaccine_needed => true
    )
  }

  #check patient profile for risk factors
  #set array of guideline numbers to profile
  def check_hbv_risk(profile)
    #order important, highest risk (requiring treatment) should go first
    gns = []
    if profile.hiv_positive
      gns.push(13)
    end
    if profile.injection_drug_user
      gns.push(3)
    end
    if profile.gay_man
      gns.push(4)
    end
    if profile.close_contacts_hbv
      gns.push(11)
    end
    if profile.hemodialysis
      gns.push(8)
    end
    if profile.immunosuppressive
      gns.push(5)
    end
    if profile.pregnant
      gns.push(9)
    end
    if profile.mother_hbv
      gns.push(10)
    end
    if HBV_PREVALENCE2[profile.country_born]
      gns.push(1)
    end
    if HBV_PREVALENCE8[profile.mother_country_born] || HBV_PREVALENCE8[profile.father_country_born]
      gns.push(2)
    end
    if profile.exposed_infected_blood_organ
      gns.push(12)
    end
    if profile.elevated_liver_enzymes
      gns.push(6)
    end
    if profile.med_donor
      gns.push(7)
    end
    profile.update_attributes(:hbv_risk_gns => gns)
  end

  #is patient at risk for HBV
  def at_risk_hbv(profile)
    return profile.hbv_risk_gns != nil && profile.hbv_risk_gns.length > 0
  end

  #return risk alert
  def show_hbv_risk_alert(profile)
    if at_risk_hbv(profile) && !profile.hbv_cared
      return "Check HBV condition for actions!"
    else
      return ""
    end
  end

  #get risk guidelines based on profile
  def get_hbv_guidelines(profile)
    gs = []
    if(profile.hbv_risk_gns)
      profile.hbv_risk_gns.each do |gn|
        gs.push(@@hbv_guidelines[gn])
      end
    end
    return gs
  end

  #deprecated
  def show_hbv_risk_guideline(profile)
    if profile.hbv_risk_gns.length > 0
      @guideline = @@hbv_guidelines[profile.hbv_risk_gns[0]]
      return
        "For patient: #{@guideline.cause} <br />
        #{@guideline.test_rec}<br />
        #{@guideline.treat_rec}<br />"
    else
      return ""
    end
  end

  #interprete hbv test results, set status
  def interpret_hbv_test_result(hbv)
    status = TEST_STATUS_UNTESTED
    if hbv.hbs_ag_neg && hbv.anti_hbc_neg && hbv.anti_hbs_neg
      status = TETS_STATUS_SUSCEPTIBLE
    elsif hbv.hbs_ag_neg && hbv.anti_hbc_pos && hbv.anti_hbs_pos
      status = TEST_STATUS_IMMUNE_NATURAL
    elsif hbv.hbs_ag_neg && hbv.anti_hbc_neg && hbv.anti_hbs_pos
      status = TEST_STATUS_IMMUNE_VACCINE
    elsif hbv.hbs_ag_pos && hbv.anti_hbc_pos && hbv.anti_hbs_neg && hbv.igm_anti_hbc_pos
      status = TEST_STATUS_INFECTED_ACUTE
    elsif hbv.hbs_ag_pos && hbv.anti_hbc_pos && hbv.anti_hbs_neg && hbv.igm_anti_hbc_neg
      status = TEST_STATUS_INFECTED_CHRONIC
    elsif hbv.hbs_ag_neg && hbv.anti_hbc_pos && hbv.anti_hbs_neg
      status = TEST_STATUS_RESULT_UNCLEAR
    elsif hbv.hbs_ag_pos || hbv.hbs_ag_neg || hbv.anti_hbc_pos || hbv.anti_hbc_neg || hbv.anti_hbs_pos || hbv.anti_hbs_neg || hbv.igm_anti_hbc_pos || hbv.igm_anti_hbc_neg
      status = TEST_STATUS_TESTED_INCOMPLETE
    end
    return status
  end

  #determine alert based on rsk and status
  def determine_hbv_test_alert(profile, test_status)
    alert = nil
    atrisk = at_risk_hbv(profile)
    if(atrisk && test_status == TEST_STATUS_UNTESTED)
      alert = "Go get testing."
    elsif(atrisk && test_status == TEST_STATUS_TESTED_INCOMPLETE)
      alert = "Go complete the tests."
    elsif (atrisk && test_status == TETS_STATUS_SUSCEPTIBLE)
      alert = "You are unprotected. Go get HBV vaccine."
    elsif (test_status == TEST_STATUS_INFECTED_ACUTE)
      alert = "Go get HAV vaccine and treatment."
    elsif (test_status == TEST_STATUS_INFECTED_CHRONIC)
      alert = "Start routine monitoring and treatment."
    end
    return alert
  end

  #if vaccine is needed but not get it, return alert
  def determine_hbv_vaccine_alert(profile, vaccines, test_status)
    @had_hbv_vac = false
    vaccines.each do |v|
      @had_hbv_vac = true if v.targetcon == "hbv"
    end

    if !@had_hbv_vac    # did not have hbv vaccine
      if(test_status == TETS_STATUS_SUSCEPTIBLE )  #need vaccine
         return "You should get HBV vaccine!"
      else
        @hbv_vac_needed = false
        @gs = get_hbv_guidelines(profile)
        if(@gs)
          @gs.each do |g|
            @hbv_vac_needed = true if g.vaccine_needed
          end
        end
        if @hbv_vac_needed   # need vaccine
          return "You should get HBV vaccine!"
        end
      end
    end
  end

  #if vaccine is needed but not get it, return alert
  def determine_hav_vaccine_alert(vaccines, test_status)
    @had_hav_vac = false
    vaccines.each do |v|
      @had_hav_vac = true if v.targetcon == "hav"
    end

    if !@had_hav_vac   # did not have hav vaccine
      if(test_status == TEST_STATUS_INFECTED_CHRONIC)
        return "You should get HAV vaccine!"
      end
    end
  end

  #if monitoring is needed but not get it, return alert
  def determine_hbv_monitoring_alert(hbv, test_status)
    if(hbv.eqtests == nil || hbv.eqtests.length == 0)  #no test done
      if(test_status == TEST_STATUS_INFECTED_CHRONIC )  #need monitoring
         return "You should start monitoring for liver cancer and liver damage!"
      end
    end
  end

  #if treatment is needed but not get it, return alert
  def determine_hbv_treatment_alert(eqcondition, test_status)
    if(eqcondition.eqtreatments.length == 0)  #no test done
      if(test_status == TEST_STATUS_INFECTED_CHRONIC )  #may need treatment
         return "You should check if early treatment is needed now!"
      end
    end
  end

end

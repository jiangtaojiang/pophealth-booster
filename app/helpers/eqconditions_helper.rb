module EqconditionsHelper
  include HbvsHelper
  include HcvsHelper


  #check if condition exists
  def patient_has_condition(patient, cdn_code)
    if(patient.eqconditions)
      patient.eqconditions.each do |c|
        if(c.code == cdn_code)
          return true
        end
      end
    end
    return false
  end

  #auto-create condition if being cared or at risk
  def auto_create_condition(patient, profile)
    begin
      @cons = {}
      #if hbv tested or at risk and hbv condition not created
      if (profile.hbv_cared || at_risk_hbv(profile)) && !patient_has_condition(patient, C_HBV_CODE)
        @eqcondition = patient.eqconditions.create!(code: C_HBV_CODE, name: C_HBV_NAME)
        @eqcondition.create_hbv()
        @cons[@eqcondition.id] = C_HBV_NAME
        puts "created condition: "+C_HBV_CODE
      end
      # hcv positive or hcv rick
      if (profile.hcv_positive || at_risk_hcv(profile)) && !patient_has_condition(patient, C_HCV_CODE)
        @eqcondition = patient.eqconditions.create!(code: C_HCV_CODE, name: C_HCV_NAME)
        @eqcondition.create_hcv()
        @cons[@eqcondition.id] = C_HCV_NAME
        puts "created condition: "+C_HCV_CODE
      end
      return @cons
    rescue Exception => e
      puts "failed to auto-create condition: "+e.message
    end
  end

  #create new hbv condition
  def auto_create_condition_hbv(patient)
    begin
      @eqcondition = patient.eqconditions.create!(code: C_HBV_CODE, name: C_HBV_NAME)
      if(@eqcondition)
        @eqcondition.create_hbv()
        puts "created condition: "+C_HBV_CODE
        return "Alert: You have a condition: "+C_HBV_NAME+". Please check the condition page for testing, monitoring or treatment."
      end
    rescue
      puts "failed to create condition: "++C_HBV_CODE
    end
  end


  #create new condition
  def create_condition(patient, cdn)
    @eqcondition = patient.eqconditions.create!(code: cdn, name: CONDITION_NAMES[cdn])
    if(@eqcondition)
      if @eqcondition.code == C_HBV_CODE
        @eqcondition.create_hbv()
      elsif @eqcondition.code == C_HCV_CODE
        @eqcondition.create_hcv()
      end
      puts "created condition: "+cdn
      return @eqcondition
    else
      puts "failed to create condition: "+cdn
      return nil
    end
  end

end

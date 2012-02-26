module EquityHelper
  include HbvsHelper
  include HcvsHelper

  M_CODE_HBV_TEST = "hbv_test"
  M_NAME_HBV_TEST = 'Testing HBV for patients at risk'
  M_CODE_HBV_VACCINE = "hbv_vaccine"
  M_NAME_HBV_VACCINE = 'Vaccinating patients who need HBV vaccine'
  M_CODE_HBV_MONITOR = "hbv_monitor"
  M_NAME_HBV_MONITOR = 'HBV positive on regular monitoring'
  M_CODE_HBV_TREAT = "hbv_treatment"
  M_NAME_HBV_TREAT = 'HBV positive on treatment'
  M_CODE_HCV_TEST = "hcv_test"
  M_NAME_HCV_TEST = 'Testing HCV for patients at risk'
  M_CODE_HCV_MONITOR = "hcv_monitor"
  M_NAME_HCV_MONITOR = 'HCV positive on regular monitoring'
  M_CODE_HCV_TREAT = "hcv_treatment"
  M_NAME_HCV_TREAT = 'HCV positive on treatment'

  # get hbv equiuty report
  def hbv_equity_report
    report = []
    equity_risk_test = Equity.new(:condition_code => C_HBV_CODE, :measure_code =>M_CODE_HBV_TEST, :measure_name => M_NAME_HBV_TEST)
    report.push(equity_risk_test)
    equity_vaccine = Equity.new(:condition_code => C_HBV_CODE, :measure_code =>M_CODE_HBV_VACCINE, :measure_name => M_NAME_HBV_VACCINE)
    report.push(equity_vaccine)
    equity_monitor = Equity.new(:condition_code => C_HBV_CODE, :measure_code =>M_CODE_HBV_MONITOR, :measure_name => M_NAME_HBV_MONITOR)
    report.push(equity_monitor)
    equity_treatment = Equity.new(:condition_code => C_HBV_CODE, :measure_code =>M_CODE_HBV_TREAT, :measure_name => M_NAME_HBV_TREAT)
    report.push(equity_treatment)

    Patient.all.each do |patient|
      patient.eqconditions.each do |c|
        if(c.code == C_HBV_CODE)
          #check tested/risk
          if(at_risk_hbv(patient.profile))
            equity_risk_test.expected_count += 1
            if c.test_status != TEST_STATUS_UNTESTED
              equity_risk_test.actual_count += 1
            end
          end

          #check vaccined/vaccine-needed
          if(c.test_status == TETS_STATUS_SUSCEPTIBLE )  #need vaccine
            equity_vaccine.expected_count += 1
          else
            get_hbv_guidelines(patient.profile).each do |g|
              if g.vaccine_needed
                equity_vaccine.expected_count += 1
                break
              end
            end
          end
          c.eqvaccines.each do |v|
            if v.targetcon == "hbv"
              equity_vaccine.actual_count += 1
              break
            end
          end

          #check monitoring
          if(c.test_status == TEST_STATUS_INFECTED_CHRONIC )  #need monitoring
            equity_monitor.expected_count += 1
          end
          if(c.hbv.eqtests.length > 0)  # has test
            equity_monitor.actual_count += 1
          end

          #check treatment
          if(c.test_status == TEST_STATUS_INFECTED_CHRONIC )  #need monitoring
            equity_treatment.expected_count += 1
          end
          if(c.eqtreatments.length > 0)  # has treatment
            equity_treatment.actual_count += 1
          end

        end
      end
    end

    cal_percentage(equity_risk_test)
    cal_percentage(equity_vaccine)
    cal_percentage(equity_monitor)
    cal_percentage(equity_treatment)

    return report
  end


  #list hbv patients related to the given equity measure
  def list_hbv_equity_patients(eq_id)
    @patients = []
    if(eq_id == 'hbv_test')
      @equity = Equity.new(:condition_code => C_HBV_CODE, :measure_code =>M_CODE_HBV_TEST, :measure_name => M_NAME_HBV_TEST)
      #scan for now; should do search later
      Patient.all.each do |patient|
        patient.eqconditions.each do |c|
          if(c.code == C_HBV_CODE)
            #check risk
            if(at_risk_hbv(patient.profile))
              @equity.expected_count += 1
              if c.test_status != TEST_STATUS_UNTESTED
                @equity.actual_count += 1
                patient.eqmeasure_meet_gl = true
              else
                patient.eqmeasure_meet_gl = false
              end
              @patients.push(patient)
            end
          end
        end
      end
    elsif(eq_id == 'hbv_vaccine')
      @equity = Equity.new(:condition_code => C_HBV_CODE, :measure_code =>M_CODE_HBV_VACCINE, :measure_name => M_NAME_HBV_VACCINE)
      #scan for now; should do search later
      Patient.all.each do |patient|
        patient.eqconditions.each do |c|
          if(c.code == C_HBV_CODE)
            #check vaccined/vaccine-needed
            if(c.test_status == TETS_STATUS_SUSCEPTIBLE )  #need vaccine
              @equity.expected_count += 1
              @patients.push(patient)
            else
              get_hbv_guidelines(patient.profile).each do |g|
                if g.vaccine_needed
                  @equity.expected_count += 1
                  @patients.push(patient)
                  break
                end
              end
            end
            c.eqvaccines.each do |v|
              if v.targetcon == "hbv"
                @equity.actual_count += 1
                patient.eqmeasure_meet_gl = true
                break
              end
            end
          end
        end
      end
    elsif(eq_id == 'hbv_monitor')
      @equity = Equity.new(:condition_code => C_HBV_CODE, :measure_code =>M_CODE_HBV_MONITOR, :measure_name => M_NAME_HBV_MONITOR)
      #scan for now; should do search later
      Patient.all.each do |patient|
        patient.eqconditions.each do |c|
          if(c.code == C_HBV_CODE)
            #check monitoring
            if(c.test_status == TEST_STATUS_INFECTED_CHRONIC )  #need monitoring
              @equity.expected_count += 1
              @patients.push(patient)
            end
            if(c.hbv.eqtests.length > 0)  # has test
              @equity.actual_count += 1
              patient.eqmeasure_meet_gl = true
            end
          end
        end
      end
    elsif(eq_id == 'hbv_treatment')
      @equity = Equity.new(:condition_code => C_HBV_CODE, :measure_code =>M_CODE_HBV_TREAT, :measure_name => M_NAME_HBV_TREAT)
      #scan for now; should do search later
      Patient.all.each do |patient|
        patient.eqconditions.each do |c|
          if(c.code == C_HBV_CODE)
            #check treatment
            if(c.test_status == TEST_STATUS_INFECTED_CHRONIC )  #need monitoring
              @equity.expected_count += 1
              @patients.push(patient)
            end
            if(c.eqtreatments.length > 0)  # has treatment
              @equity.actual_count += 1
              patient.eqmeasure_meet_gl = true
            end
          end
        end
      end
    else
      @equity = Equity.new
    end
    cal_percentage(@equity)
  end

  # get hcv equiuty report
  def hcv_equity_report
    report = []
    equity_risk_test = Equity.new(:condition_code => C_HCV_CODE, :measure_code =>M_CODE_HCV_TEST, :measure_name => M_NAME_HCV_TEST)
    report.push(equity_risk_test)
    equity_monitor = Equity.new(:condition_code => C_HCV_CODE, :measure_code =>M_CODE_HCV_MONITOR, :measure_name => M_NAME_HCV_MONITOR)
    report.push(equity_monitor)
    equity_treatment = Equity.new(:condition_code => C_HCV_CODE, :measure_code =>M_CODE_HCV_TREAT, :measure_name => M_NAME_HCV_TREAT)
    report.push(equity_treatment)

    Patient.all.each do |patient|
      patient.eqconditions.each do |c|
        if(c.code == C_HCV_CODE)
          #check rist/test
          if(at_risk_hcv(patient.profile))
            equity_risk_test.expected_count += 1
            if c.test_status != TEST_STATUS_UNTESTED
              equity_risk_test.actual_count += 1
            end
          end

          #check monitoring
          if(c.test_status == TEST_STATUS_INFECTED )  #need monitoring
            equity_monitor.expected_count += 1
          end
          if(c.hcv.eqtests.length > 0)  # has test
            equity_monitor.actual_count += 1
          end

          #check treatment
          if(c.test_status == TEST_STATUS_INFECTED )  #need treatment
            equity_treatment.expected_count += 1
          end
          if(c.eqtreatments.length > 0)  # has treatment
            equity_treatment.actual_count += 1
          end

        end
      end
    end

    cal_percentage(equity_risk_test)
    cal_percentage(equity_monitor)
    cal_percentage(equity_treatment)

    return report
  end


  #list hcv patients related to the given equity measure
  def list_hcv_equity_patients(eq_id)
    @patients = []
    if(eq_id == 'hcv_test')
      @equity = Equity.new(:condition_code => C_HCV_CODE, :measure_code =>M_CODE_HCV_TEST, :measure_name => M_NAME_HCV_TEST)
      #scan for now; should do search later
      Patient.all.each do |patient|
        patient.eqconditions.each do |c|
          if(c.code == C_HCV_CODE)
            #check rist/test
            if(at_risk_hcv(patient.profile))
              @equity.expected_count += 1
              if c.test_status != TEST_STATUS_UNTESTED
                @equity.actual_count += 1
                patient.eqmeasure_meet_gl = true
              end
              @patients.push(patient)
            end
          end
        end
      end
    elsif(eq_id == 'hcv_monitor')
      @equity = Equity.new(:condition_code => C_HCV_CODE, :measure_code =>M_CODE_HCV_MONITOR, :measure_name => M_NAME_HCV_MONITOR)
      #scan for now; should do search later
      Patient.all.each do |patient|
        patient.eqconditions.each do |c|
          if(c.code == C_HCV_CODE)
            #check monitoring
            if(c.test_status == TEST_STATUS_INFECTED )  #need monitoring
              @equity.expected_count += 1
              @patients.push(patient)
            end
            if(c.hcv.eqtests.length > 0)  # has test
              @equity.actual_count += 1
              patient.eqmeasure_meet_gl = true
            end
          end
        end
      end
    elsif(eq_id == 'hcv_treatment')
      @equity = Equity.new(:condition_code => C_HCV_CODE, :measure_code =>M_CODE_HCV_TREAT, :measure_name => M_NAME_HCV_TREAT)
      #scan for now; should do search later
      Patient.all.each do |patient|
        patient.eqconditions.each do |c|
          if(c.code == C_HCV_CODE)
            #check treatment
            if(c.test_status == TEST_STATUS_INFECTED )  #need treatment
              @equity.expected_count += 1
              @patients.push(patient)
            end
            if(c.eqtreatments.length > 0)  # has treatment
              @equity.actual_count += 1
              patient.eqmeasure_meet_gl = true
            end
          end
        end
      end
    else
      @equity = Equity.new
    end
    cal_percentage(@equity)
  end

  #calculate equity percentage
  def cal_percentage(equity)
    if(equity.expected_count > 0)
      equity.percentage = 100.0 * equity.actual_count / equity.expected_count
    end
  end

end

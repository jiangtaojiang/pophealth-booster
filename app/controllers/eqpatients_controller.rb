class EqpatientsController < ApplicationController
  include EqconditionsHelper

  before_filter :authenticate_user!
  before_filter :set_current_patient
  skip_authorization_check

  # GET /patients
  # GET /patients.xml
  def index
    if(params[:q])
      @q = params[:q].strip
      #by id
      @patients = Patient.where(:member_id=>@q)
      if(@patients.length == 0)                        #
        #by first name
        @patients = Patient.all(conditions: {firstname: Regexp.new("^#{@q}", Regexp::IGNORECASE)}, limit:100)
        if(@patients.length == 0)                        #
          #by last name
          @patients = Patient.all(conditions: {lastname: Regexp.new("^#{@q}", Regexp::IGNORECASE)}, limit:100)
        end
      end
    else
      @patients = Patient.all.limit(100)
    end

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @patients }
    end
  end

  # GET /patients/1
  # GET /patients/1.xml
  def show
    @patient = Patient.find(params[:id])

    # Save patient ID in the session
    session[:current_patient_id] = @patient.id
    set_current_patient

    # set alert
    @patient.eqconditions.each do |c|
      if c.code == C_HBV_CODE
        c.alert_test = determine_hbv_test_alert(@patient.profile, c.test_status)
        c.alert_vaccine = determine_hbv_vaccine_alert(@patient.profile, c.eqvaccines, c.test_status)
        c.alert_monitor = determine_hbv_monitoring_alert(c.hbv, c.test_status)
        c.alert_treatment = determine_hbv_treatment_alert(c, c.test_status)
      elsif c.code == C_HCV_CODE
        c.alert_test = determine_hcv_test_alert(@patient.profile, c.test_status)
        c.alert_monitor = determine_hcv_monitoring_alert(c.hcv, c.test_status)
        c.alert_treatment = determine_hcv_treatment_alert(c, c.test_status)
      end
    end

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @patient }
    end
  end

  # GET /patients/new
  # GET /patients/new.xml
  def new
    @patient = Patient.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @patient }
    end
  end

  # GET /patients/1/edit
  def edit
    @patient = Patient.find(params[:id])
  end

  # POST /patients
  # POST /patients.xml
  def create
    #how to check unique patient? name + memberId

    @patient = Patient.new(params[:patient])
    @profile = @patient.build_profile();

    respond_to do |format|
      if @patient.save && @profile.save
        # Save patient ID in the session
        session[:current_patient_id] = @patient.id
        set_current_patient

        format.html { redirect_to(show_patient_path(@patient), :notice => 'Patient was successfully created.') }
        format.xml  { render :xml => @patient, :status => :created, :location => @patient }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @patient.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /patients/1
  # PUT /patients/1.xml
  def update
    @patient = Patient.find(params[:id])

    respond_to do |format|
      if @patient.update_attributes(params[:patient])
        format.html { redirect_to(list_patients_path, :notice => 'Patient was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @patient.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /patients/1
  # DELETE /patients/1.xml
  def destroy
    @patient = Patient.find(params[:id])
    @name = @patient.firstname+" "+@patient.lastname+", ID = "+@patient.member_id
    @patient.eqconditions.destroy_all
    @patient.profile.destroy
    @patient.destroy

    @current_patient_id = session[:current_patient_id] = nil
    set_current_patient
    puts "removed patient: "+ @name

    respond_to do |format|
      format.html { redirect_to(list_patients_path, :notice => "Removed patient: #{@name}") }
      format.xml  { head :ok }
    end
  end
end

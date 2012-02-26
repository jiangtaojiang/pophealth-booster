class EqconditionsController < ApplicationController
  include EqconditionsHelper
  include HbvsHelper
  include HcvsHelper

  before_filter :authenticate_user!
  before_filter :set_current_patient
  skip_authorization_check

  # GET /conditions/1/new
  def new
    @patient = Patient.find(params[:id])
    @eqcondition = @patient.eqconditions.new()
    render :action => "new"
  end

  # POST /conditions/1/create
  # create a condition if it does not exist yet
  def create
    @patient = Patient.find(params[:id])
    #@cdn = params[:eqcondition][:code]
    @cdn = params[:code]
    if patient_has_condition(@patient, @cdn)
      redirect_to(new_condition_path, :notice => "Condition already exists!")
    else
      @eqcondition = create_condition(@patient, @cdn)
      if @eqcondition
        redirect_to(edit_condition_url(@patient.id, @eqcondition.id), :notice => "Condition created!")
      else
        redirect_to(new_condition_path, :notice => "Condition not created!")
      end
    end
  end

  # GET conditions/edit/:id/:cdn_id
  # show condiition edit form, check status and alerts
  def edit
    @patient = Patient.find(params[:id])
    @profile = @patient.profile
    @eqcondition = Eqcondition.find(params[:cdn_id])
    @test_status = @eqcondition.test_status
    if @eqcondition.code == C_HBV_CODE
      @hbv = @eqcondition.hbv
      @guidelines = get_hbv_guidelines(@profile)
      @test_alert = determine_hbv_test_alert(@profile, @test_status)
      @hbv_vaccine_alert = determine_hbv_vaccine_alert(@profile, @eqcondition.eqvaccines, @test_status)
      @hav_vaccine_alert = determine_hav_vaccine_alert(@eqcondition.eqvaccines, @test_status)
      @monitoring_alert = determine_hbv_monitoring_alert(@hbv, @test_status)
      render :action => "edit_hbv"
    elsif @eqcondition.code == C_HCV_CODE
      @hcv = @eqcondition.hcv
      @guidelines = get_hcv_guidelines(@profile)
      @test_alert = determine_hcv_test_alert(@profile, @test_status)
      @monitoring_alert = determine_hcv_monitoring_alert(@hcv, @test_status)
      @treatment_alert = determine_hcv_treatment_alert(@eqcondition, @test_status)
      render :action => "edit_hcv"
    else
      render :action => "edit"
    end
  end

  # POST conditions/update/:id/:cdn_id
  def update
    @patient = Patient.find(params[:id])
    @profile = @patient.profile
    @eqcondition = Eqcondition.find(params[:cdn_id])
    render :action => "edit"
  end

  # GET /conditions/remove/:id/:cdn_id
  def destroy
    @patient = Patient.find(params[:id])
    @eqcondition = Eqcondition.find(params[:cdn_id])
    @cdn_code = @eqcondition.code
    @cdn_name = @eqcondition.name
    @patient.eqconditions.where(_id: params[:cdn_id]).destroy_all
    puts "destroyed condition: "+@cdn_code +"; patient: "+@patient.member_id
    redirect_to(show_patient_path(@patient), :notice => "Removed condition: "+@cdn_name)
  end

  # POST conditions/vaccine/add/:id/:cdn_id
  def add_vaccine
    @patient = Patient.find(params[:id])
    @eqcondition = Eqcondition.find(params[:cdn_id])
    @eqvaccines = @eqcondition.eqvaccines.create!(params[:vac])
    redirect_to(edit_condition_url(@patient.id, @eqcondition.id), :notice => "Added Vaccine!")
  end

  #GET conditions/vaccine/remove/:id/:cdn_id/:vac_id
  def remove_vaccine
    @patient = Patient.find(params[:id])
    @eqcondition = Eqcondition.find(params[:cdn_id])
    @eqcondition.eqvaccines.where(_id: params[:vac_id]).destroy_all
    redirect_to(edit_condition_url(@patient.id, @eqcondition.id), :notice => "Removed Vaccine!")
  end

  # POST conditions/treatment/add/:id/:cdn_id
  def add_treatment
    @patient = Patient.find(params[:id])
    @eqcondition = Eqcondition.find(params[:cdn_id])
    @eqtreatment = @eqcondition.eqtreatments.create!(params[:tr])
    redirect_to(edit_condition_url(@patient.id, @eqcondition.id), :notice => "Added Treatment!")
  end

  def update_treatment
    @patient = Patient.find(params[:id])
    @eqcondition = Eqcondition.find(params[:cdn_id])
    @hbv = @eqcondition.hbv
    @eqtreatment = @hbv.eqtreatments.find(params[:tr_id])
    @eqtreatment.update_attributes(params[:tr])
    render :template => "edit_hbv"
  end

  # GET conditions/treatment/remove/:id/:cdn_id/:tr_id
  def remove_treatment
    @patient = Patient.find(params[:id])
    @eqcondition = Eqcondition.find(params[:cdn_id])
    @eqcondition.eqtreatments.where(_id: params[:tr_id]).destroy_all
    redirect_to(edit_condition_url(@patient.id, @eqcondition.id), :notice => "Removed Treatment!")
  end

end

class ProfilesController < ApplicationController
  include ProfilesHelper
  include EqconditionsHelper

  before_filter :set_current_patient
  before_filter :set_current_patient
  skip_authorization_check

  # GET /profiles
  # GET /profiles.xml
  def index
    @profiles = Profile.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @profiles }
    end
  end

  # GET /profiles/1
  # GET /profiles/1.xml
  def show
    @profile = Profile.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @profile }
    end
  end

  # GET /profiles/new
  # GET /profiles/new.xml
  def new
    @profile = Profile.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @profile }
    end
  end

  # POST /profiles
  # POST /profiles.xml
  def create
    @profile = Profile.new(params[:profile])

    respond_to do |format|
      if @profile.save
        format.html { redirect_to(@profile, :notice => 'Profile was successfully created.') }
        format.xml  { render :xml => @profile, :status => :created, :location => @profile }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @profile.errors, :status => :unprocessable_entity }
      end
    end
  end

  # GET /profiles/1/edit
  def edit
    @patient = Patient.find(params[:id])
    session[:current_patient_id] = @patient.id
    set_current_patient

    @profile = @patient.profile
    render :template => "profiles/edit"
  end

  # PUT /patients/1
  # PUT /patients/1.xml
  def update
    @patient = Patient.find(params[:id])
    @profile = @patient.profile
    @profile.update_attributes(params[:profile])
    check_risks(@profile)
    @new_conditions = auto_create_condition(@patient, @profile)
    render :template => "profiles/edit"
    #redirect_to(edit_patient_profile_path(@patient), :notice => @msg)
  end

  # DELETE /profiles/1
  # DELETE /profiles/1.xml
  def destroy
    @profile = Profile.find(params[:id])
    @profile.destroy

    respond_to do |format|
      format.html { redirect_to(profiles_url) }
      format.xml  { head :ok }
    end
  end
end

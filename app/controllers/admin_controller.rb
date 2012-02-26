class AdminController < ApplicationController

  before_filter :authenticate_user!
  before_filter :validate_authorization!
  add_breadcrumb 'admin', :admin_users_path

  def users
    @users = User.all.ordered_by_username
  end

  def promote
    toggle_privilidges(params[:username], params[:role], :promote)
  end

  def demote
    toggle_privilidges(params[:username], params[:role], :demote)
  end

  def disable
    user = User.by_username(params[:username]);
    disabled = params[:disabled].to_i == 1
    if user
      user.update_attribute(:disabled, disabled)
      if (disabled)
        render :text => "<a href=\"#\" class=\"disable\" data-username=\"#{user.username}\">disabled</span>"
      else
        render :text => "<a href=\"#\" class=\"enable\" data-username=\"#{user.username}\">enabled</span>"
      end
    else
      render :text => "User not found"
    end
  end

  def approve
    user = User.first(:conditions => {:username => params[:username]})
    if user
      user.update_attribute(:approved, true)
      render :text => "true"
    else
      render :text => "User not found"
    end
  end

  def update_npi
    user = User.by_username(params[:username]);
    user.update_attribute(:npi, params[:npi]);
    render :text => "true"
  end

  private

  def toggle_privilidges(username, role, direction)
    user = User.by_username username

    if user
      if direction == :promote
        user.update_attribute(role, true)
        render :text => "Yes - <a href=\"#\" class=\"demote\" data-role=\"#{role}\" data-username=\"#{username}\">revoke</a>"
      else
        user.update_attribute(role, false)
        render :text => "No - <a href=\"#\" class=\"promote\" data-role=\"#{role}\" data-username=\"#{username}\">grant</a>"
      end
    else
      render :text => "User not found"
    end
  end

  def validate_authorization!
    authorize! :admin, :users
  end
  
  
  
  #########admin patients for equity###############

  public
  include HbvsHelper
  include HcvsHelper

  def admin_patients
    @patients = Patient.all
    render :template => "admin/patients"
  end

  #create equity patients from patient records
  def randomize_patients
    #r = mongo['records'].find_one()
    mongo['records'].find().each do |r|
      puts r.inspect
      @patient = Patient.new(:firstname => r['first'], :lastname => r['last'], :member_id => r['patient_id'])
      @profile = @patient.build_profile();
      @patient.save && @profile.save
      puts "created patient: "+ @patient.inspect
      #break
    end

    render :text => "created random patients"
  end

  #create random hbv condition
  def randomize_hbvs
    i = 0
    Patient.all.each do |p|
      if(i < 110)
        @profile = p.profile
        @eqcondition = p.eqconditions.create!(code: C_HBV_CODE, name: C_HBV_NAME)
        @hbv = @eqcondition.create_hbv()
        if(i < 100)
          #100 born in china
          @profile.update_attributes(:country_born => "CN")
          if(i < 50)
            #50 tested negative
            @hbv.update_attributes(:hbs_ag_neg => true, :anti_hbc_pos => true, :anti_hbs_pos => true)
          elsif(i>= 50 && i < 60)
            #10 tested positive
            @hbv.update_attributes(:hbs_ag_pos => true, :anti_hbc_pos => true, :anti_hbs_neg => true, :igm_anti_hbc_neg => true)
            if(i>= 50 && i < 55)
              #5 on monitor
              @hbv.eqtests.create!(:date => "2000/11/11", :afp => "positive")
            elsif(i>=55 && i<60)
              #5 treated
              @eqcondition.eqtreatments.create!(:start => "2000/11/11", :medname => "HBV drug")
            end
          end
        elsif(i >= 100 && i < 110)
          #10 close contact with hbv+
          @profile.update_attributes(:close_contacts_hbv => true)
          #10 tested positive
          @hbv.update_attributes(:hbs_ag_pos => true, :anti_hbc_pos => true, :anti_hbs_neg => true, :igm_anti_hbc_neg => true)
          #10 vaccinated
          @eqcondition.eqvaccines.create!(:targetcon => 'hbv', :vaccine => 'Engerix-B', :date => '2000/11/11', :order => 1)
        end

        #recheck status
        check_hbv_risk(@profile)
        @test_status = interpret_hbv_test_result(@hbv)
        @eqcondition.update_attributes(:test_status => @test_status)

      else
        break
      end

      i += 1
    end

    render :text => "created random hbv conditions"
  end

  #create random hcv condition
  def randomize_hcvs
    i = 0
    Patient.all.each do |p|
      if(i >= 200 && i < 300)
        @profile = p.profile
        @eqcondition = p.eqconditions.create!(code: C_HCV_CODE, name: C_HCV_NAME)
        @hcv = @eqcondition.create_hcv()

        #100 hiv positive, at risk
        @profile.update_attributes(:hiv_positive => true)
        if(i >= 200 && i < 250)
          #50 tested negative
          @hcv.update_attributes(:anti_hcv_neg => true)
        elsif(i>= 250 && i < 300)
          #50 tested positive
          @hcv.update_attributes(:anti_hcv_pos => true, :hcv_riba_pos => true )
          #50 treated
          @eqcondition.eqtreatments.create!(:start => "2000/11/11", :medname => "HCV drug")
        end

        #recheck status
        check_hcv_risk(@profile)
        @test_status = interpret_hcv_test_result(@hcv)
        @eqcondition.update_attributes(:test_status => @test_status)

      elsif(i >= 300)
        break
      end

      i += 1
    end

    render :text => "created random hcv conditions"
  end

  def clear_patients
    Patient.all.each do |patient|
      patient.eqconditions.destroy_all
      patient.profile.destroy
      patient.destroy

      session[:current_patient_id] = nil
      set_current_patient
    end
    render :text => "removed all patients"
  end

end

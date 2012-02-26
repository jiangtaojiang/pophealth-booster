require 'breadcrumbs'
class ApplicationController < ActionController::Base
  protect_from_forgery
  include Breadcrumbs
  layout :layout_by_resource
  before_filter :set_effective_date
  
  add_breadcrumb APP_CONFIG['practice_name'], :root_url
  
  # lock it down!
  check_authorization :unless => :devise_controller?
  
  private

  # Overwriting the sign_out redirect path method
  def after_sign_out_path_for(resource_or_scope)
    '/logout.html'
  end
  
  def hash_document
    d = Digest::SHA1.new
    checksum = d.hexdigest(response.body)
    Log.create(:username => current_user.username, :event => 'document exported', :checksum => checksum)
  end

  def layout_by_resource
    if devise_controller?
      "users"
    else
      "application"
    end
  end
  
  rescue_from CanCan::AccessDenied do |exception|
    redirect_to "#{root_url}403.html", :alert => exception.message
  end

  def mongo
    MONGO_DB
  end
  
  def set_effective_date(effective_date=nil, persist=false)
    if (effective_date)
      @effective_date = effective_date
      current_user.update_attribute(:effective_date, effective_date) if persist
    elsif current_user && current_user.effective_date
      @effective_date = current_user.effective_date
    else
      @effective_date = User::DEFAULT_EFFECTIVE_DATE.to_i
    end
    @period_start = calc_start(@effective_date)
  end
  
  def calc_start(date)
    3.months.ago(Time.at(date))
  end

  ######booster###########
  
  def set_current_patient
    if session[:current_patient_id]
      begin
        @current_patient = Patient.find(session[:current_patient_id])
        if(@current_patient)
          @current_patient_name = @current_patient.firstname+" "+@current_patient.lastname
        end
      rescue
        puts "can't find "+ session[:current_patient_id].to_s
        @current_patient = nil
      end
    else
      @current_patient = nil
    end
  end

end

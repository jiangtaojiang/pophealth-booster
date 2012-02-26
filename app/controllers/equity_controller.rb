class EquityController < ApplicationController
  include EquityHelper

  before_filter :authenticate_user!
  before_filter :set_current_patient
  skip_authorization_check
  
  def index
    @reports = {}
    @reports['hbv'] = hbv_equity_report
    @reports['hcv'] = hcv_equity_report

    render :template => "equity/index"
  end

  def show_patients
    @cdn_id = params[:cdn_id]
    @eqm_id = params[:eqm_id]
    if(@cdn_id == C_HBV_CODE)
      list_hbv_equity_patients(@eqm_id)
    elsif(@cdn_id == C_HCV_CODE)
      list_hcv_equity_patients(@eqm_id)
    end

    render :template => "equity/show"
  end

  def help
    render :template => "equity/help"
  end

  def demo
    render :template => "equity/demo"
  end

end

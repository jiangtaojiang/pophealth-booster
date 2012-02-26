class HbvsController < ApplicationController
  include HbvsHelper

  before_filter :set_current_patient
  skip_authorization_check

  # update hbv test results and interpret it
  # POST conditions/hbv/update/:id/:cdn_id
  def update
    @patient = Patient.find(params[:id])
    @eqcondition = Eqcondition.find(params[:cdn_id])
    @hbv = @eqcondition.hbv
    @hbv.update_attributes(params[:hbv])

    #recheck status
    @test_status = interpret_hbv_test_result(@hbv)
    @eqcondition.update_attributes(:test_status => @test_status)

    redirect_to(edit_condition_url(@patient.id, @eqcondition.id), :notice => "Tests saved!")
  end

  # add monitoring test
  # POST conditions/hbv/monitor/add/:id/:cdn_id
  def add_test
    @patient = Patient.find(params[:id])
    @eqcondition = Eqcondition.find(params[:cdn_id])
    @hbv = @eqcondition.hbv
    @eqtests = @hbv.eqtests.create!(params[:test])
    redirect_to(edit_condition_url(@patient.id, @eqcondition.id), :notice => "Added monitoring test!")
  end

  # remove monitoring test
  # GET conditions/hbv/monitor/remove/:id/:cdn_id/:dx_id
  def remove_test
    @patient = Patient.find(params[:id])
    @eqcondition = Eqcondition.find(params[:cdn_id])
    @hbv = @eqcondition.hbv
    @hbv.eqtests.where(_id: params[:dx_id]).destroy_all
    redirect_to(edit_condition_url(@patient.id, @eqcondition.id), :notice => "Removed monitoring test!")
  end

end

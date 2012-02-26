class HcvsController < ApplicationController
  include HcvsHelper

  before_filter :set_current_patient
  skip_authorization_check

  # update hcv test results and interpret it
  # POST conditions/hcv/update/:id/:cdn_id
  def update
    @patient = Patient.find(params[:id])
    @eqcondition = Eqcondition.find(params[:cdn_id])
    @hcv = @eqcondition.hcv
    @hcv.update_attributes(params[:hcv])

    #recheck status
    @test_status = interpret_hcv_test_result(@hcv)
    @eqcondition.update_attributes(:test_status => @test_status)

    redirect_to(edit_condition_url(@patient.id, @eqcondition.id), :notice => "Tests saved!")
  end

end

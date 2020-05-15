# frozen_string_literal: true

# Generate river wateflow report and send it via email
class ReportsController < ApplicationController
  def new
    render :new, locals: { report_form: ReportForm.new, rivers: River.for_select }
  end

  def create
    report_form = ReportForm.new report_form_params
    if report_form.valid?
      call_worker(report_form)
      flash.now[:success] = 'El reporte será enviado a tu correo'
    else
      flash.now[:error] = 'Fallido'
    end
    render :new, locals: { report_form: report_form, rivers: River.for_select }
  end

  private

  def report_form_params
    params.require(:report_form).permit(:start_date, :end_date, :river_id)
  end

  def call_worker(report_form)
    Reports::RiverWorker.perform_async(
      report_form.river_id,
      report_form.start_date.to_s,
      report_form.end_date.to_s,
      current_user.email
    )
  end
end

# frozen_string_literal: true

# Manages generation for river reports
class ReportsController < ApplicationController
  before_action :require_login

  def new
    render :new, locals: { report_form: ReportForm.new, rivers: River.for_select }
  end

  def create
    report_form = ReportForm.new report_form_params
    if report_form.valid?
      call_worker(report_form)
      flash.now[:success] = I18n.t('flash.success.report')
    else
      flash.now[:error] = I18n.t('flash.failure.report')
    end
    render :new, locals: { report_form: report_form, rivers: River.for_select }
  end

  private

  def report_form_params
    params.require(:report_form).permit(:start_date, :end_date, :river_id)
  end

  def call_worker(report_form)
    RiverReportWorker.perform_async(
      report_form.river_id,
      report_form.start_date.to_s,
      report_form.end_date.to_s,
      current_user.email
    )
  end
end

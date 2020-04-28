# frozen_string_literal: true

# Shows reports
class ReportsController < ApplicationController
  def new
    render :new, locals: { report_form: ReportForm.new, rivers: River.for_select }
  end

  def create
    report_form = ReportForm.new report_form_params
    if report_form.valid?
      flash.now[:success] = 'Creado'
    else
      flash.now[:error] = 'Fallido'
    end
    render :new, locals: { report_form: report_form, rivers: River.for_select }
  end

  private

  def report_form_params
    params.require(:report_form).permit(:start_date, :end_date, :river_id)
  end
end

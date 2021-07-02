# frozen_string_literal: true

# Gage CRUD
class GagesController < ApplicationController
  before_action :require_login

  def index
    pagy, gages = pagy(Gage.all.order(:id))
    render(GageIndexComponent.new(gages: gages, pagy: pagy))
  end

  def new
    render(
      :new,
      locals: {
        gage: Gage.new
      }
    )
  end

  def create
    gage = Gage.new(gage_params)
    if gage.save
      flash[:success] = I18n.t('flash.success.create')
      redirect_to :gages
    else
      flash[:error] = I18n.t('flash.failure.create')
      render(:new, locals: { gage: gage })
    end
  end

  def edit
    render(
      :edit,
      locals: {
        gage: Gage.find(params[:id])
      }
    )
  end

  def update
    gage = Gage.find params[:id]

    if gage.update(gage_params)
      flash[:success] = I18n.t('flash.success.update')
      redirect_to :gages
    else
      flash[:error] = I18n.t('flash.failure.update')
      render(:edit, locals: { gage: gage })
    end
  end

  def destroy
    gage = Gage.find params[:id]

    gage.destroy
    redirect_to :gages
  end

  private

  def gage_params
    params.require(:gage).permit(
      :name,
      :ibcw_id,
      :url,
      :offset_hours,
      :offset_minutes
    )
  end

  def page_title
    'Medidores'
  end
end

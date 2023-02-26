# frozen_string_literal: true

# Gage CRUD
class GagesController < ApplicationController
  before_action :require_login
  before_action :require_admin, only: %i[new create edit update destroy]

  def index
    gages = Gage.search_or_all_with_waterflows(params[:search])
    flash.now[:warning] = t('flash.without_results') if gages.empty?
    pagy, gages = pagy(gages)

    render(GageIndexComponent.new(gages:, pagy:, search: params[:search]))
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
      redirect_to edit_gage_path gage
    else
      flash[:error] = I18n.t('flash.failure.create')
      render(:new, locals: { gage: })
    end
  end

  def edit
    render GageComponent.new(gage: Gage.find(params[:id]))
  end

  def update
    gage = Gage.find params[:id]

    if gage.update(gage_params)
      flash[:success] = I18n.t('flash.success.update')
      redirect_to edit_gage_path gage
    else
      flash[:error] = I18n.t('flash.failure.update')
      render(:edit, locals: { gage: })
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
      :offset_minutes,
      :latitude,
      :longitude
    )
  end

  def page_title
    'Medidores'
  end

  def require_admin
    return if current_user.admin?

    flash[:error] = I18n.t('flash.unauthorized')
    redirect_to gages_path
  end
end

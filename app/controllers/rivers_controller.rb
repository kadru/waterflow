# frozen_string_literal: true

# River CRUD
class RiversController < ApplicationController
  before_action :require_login

  def index
    pagy, rivers = pagy(River.all.order(:id))
    render(RiverIndexComponent.new(rivers: rivers, pagy: pagy))
  end

  def new
    render(
      :new,
      locals: {
        river: River.new
      }
    )
  end

  def create
    river = River.new(river_params)
    if river.save
      flash[:success] = I18n.t('flash.success.create')
      redirect_to :rivers
    else
      flash[:error] = I18n.t('flash.failure.create')
      render(:new, locals: { river: river })
    end
  end

  def edit
    render(
      :edit,
      locals: {
        river: River.find(params[:id])
      }
    )
  end

  def update
    river = River.find params[:id]

    if river.update(river_params)
      flash[:success] = I18n.t('flash.success.update')
      redirect_to :rivers
    else
      flash[:error] = I18n.t('flash.failure.update')
      render(:edit, locals: { river: river })
    end
  end

  def destroy
    river = River.find params[:id]

    river.destroy
    redirect_to :rivers
  end

  private

  def river_params
    params.require(:river).permit(
      :name,
      :ibcw_id,
      :url,
      :offset_hours,
      :offset_minutes
    )
  end

  def page_title
    'Rios'
  end
end

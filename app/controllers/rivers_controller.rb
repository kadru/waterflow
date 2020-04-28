# frozen_string_literal: true

# River CRUD
class RiversController < ApplicationController
  def index
    pagy, rivers = pagy(River.all)
    render(
      :index,
      locals: {
        rivers: rivers,
        pagy: pagy
      }
    )
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
      flash[:success] = 'Creado'
      redirect_to :rivers
    else
      flash[:error] = 'Fallido'
      render(:new, locals: { river: river })
    end
  end

  private

  def river_params
    params.require(:river).permit(:name, :ibcw_id, :url, :time_zone)
  end

  def page_title
    'Rios'
  end
end

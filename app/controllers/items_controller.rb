class ItemsController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :render_not_found
  rescue_from ActiveRecord::RecordInvalid, with: :render_unprocessable_entity

  def index

    if(params[:user_id])
      user = User.find(params[:user_id])
      items = user.items
    else
      items = Item.all
    end
    render json: items, include: :user , status: :ok
  end

  def show
    if(params[:user_id])
      user = User.find(params[:user_id])
      item = user.items.find(params[:id])
    else
      item = Item.find(params[:id])
    end
    render json: item, include: :user , status: :ok
  end

  def create
    new_item = Item.create!(name: params[:name], description: params[:description], price: params[:price], user_id: params[:user_id])
  
    render json: new_item, status: :created

  end

  private

  def render_unprocessable_entity(invalid)
    render json: {errors: invalid.errors.full_messages}, status: :unprocessable_entity
  end

  def render_not_found (error)
    render json: {errors: {error.model => "Not Found"}}, status: :not_found
  end

end

class Profile::ReviewsController < ApplicationController
  # before_action :require_reguser
  def index
    @reviews = Review.where(user: current_user.id)
  end

  def new
    @order_item_id = params[:oitem_id]
    @review = Review.new
  end

  def create
    @order_item_id = params[:oitem_id]
    @review = current_user.reviews.new(new_params)
    if @review.save
      flash[:new] = "Your review for #{@review.item_reviewed.name} has been created!"
      redirect_to profile_order_path(@review.order_item.order_id)
    else
      flash[:errors] = @review.errors.full_messages.join(", ")
      render :new
    end
  end

  def edit
    @review = current_review
  end

  def update
    @review = current_review
    if @review.update(update_params)
      flash[:update] = "Review for #{@review.item_reviewed.name} has been updated!"
      redirect_to profile_reviews_path
    else
      flash[:errors] = @review.errors.full_messages.join(", ")
      render :edit
    end
  end

  def destroy
    @review = current_review
    @review.destroy
    flash[:destroy] = "Review for #{@review.title} has been deleted!"
    redirect_to profile_reviews_path
  end

  private

  def current_review
    Review.find(params[:id])
  end

  def current_order
    current_review.order_item.order_id
  end

  def current_item
    current_review.order_item.order_id
  end

  def new_params
    params.require(:review).permit(:title, :rating, :description, :order_item_id)
  end

  def update_params
    params.require(:review).permit(:title, :rating, :description)
  end
end

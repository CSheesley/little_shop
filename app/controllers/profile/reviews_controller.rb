class Profile::ReviewsController < ApplicationController
  # before_action :require_reguser
  def index
    @reviews = Review.where(user: current_user.id)
  end

  def new
  end

  def create
  end

  def edit
    @review = current_review
  end

  def update
    @review = current_review
    if @review.update(update_params)
      flash[:update] = "Review for #{@review.title} has been updated!"
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

  def update_params
    params.require(:review).permit(:title, :rating, :description)
  end
end

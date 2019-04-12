class Profile::ReviewsController < ApplicationController
  # before_action :require_reguser
  def index
    @reviews = Review.where(user: current_user.id)
  end
end

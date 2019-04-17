class MerchantsController < ApplicationController
  def index
    if current_admin?
      @merchants = User.where(role: :merchant)
    else
      @merchants = User.active_merchants
    end
    @top_three_merchants_by_revenue = @merchants.top_merchants_by_revenue(3)
    @top_three_merchants_by_fulfillment = @merchants.top_merchants_by_fulfillment_time(3)
    @bottom_three_merchants_by_fulfillment = @merchants.bottom_merchants_by_fulfillment_time(3)
    @top_states_by_order_count = User.top_user_states_by_order_count(3)
    @top_cities_by_order_count = User.top_user_cities_by_order_count(3)
    @top_orders_by_items_shipped = Order.sorted_by_items_shipped(3)

    @merch_top_ten_by_items_current_month = User.top_merchants_by_items_sold_between(10, Time.now, 31.days.ago)
    @merch_top_ten_by_items_previous_month = User.top_merchants_by_items_sold_between(10, 31.days.ago, 61.days.ago)

    @merch_top_ten_by_orders_current_month = User.top_merchants_by_non_cancelled_orders_between(10, Time.now, 31.days.ago)
    @merch_top_ten_by_orders_previous_month = User.top_merchants_by_non_cancelled_orders_between(10, 31.days.ago, 61.days.ago)

    
  end
end

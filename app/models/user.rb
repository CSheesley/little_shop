class User < ApplicationRecord
  has_secure_password

  enum role: [:default, :merchant, :admin]

  validates_presence_of :name, :address, :city, :state, :zip
  validates :email, presence: true, uniqueness: true

  # as a consumer
  has_many :reviews
  has_many :orders
  has_many :order_items, through: :orders

  # as a merchant
  has_many :items, foreign_key: 'merchant_id'

  def active_items
    items.where(active: true).order(:name)
  end

  def top_items_sold_by_quantity(limit)
    items.joins(order_items: :order)
         .where(order_items: {fulfilled: true}, orders: {status: :shipped})
         .select('items.id, items.name, sum(order_items.quantity) as quantity')
         .group(:id)
         .order('quantity DESC, id')
         .limit(limit)
  end

  def total_items_sold
    items.joins(order_items: :order)
         .where(order_items: {fulfilled: true}, orders: {status: :shipped})
         .pluck('sum(order_items.quantity)')
         .first
  end

  def percent_of_items_sold
    ((total_items_sold.to_f / total_inventory_remaining.to_f)*100)
  end

  def total_inventory_remaining
    items.sum(:inventory)
  end

  def top_states_by_items_shipped(limit)
    items.joins(:order_items)
         .joins('join orders on orders.id = order_items.order_id')
         .joins('join users on users.id = orders.user_id')
         .where(order_items: {fulfilled: true}, orders: {status: :shipped})
         .group('users.state')
         .select('users.state, sum(order_items.quantity) AS quantity')
         .order('quantity DESC')
         .limit(limit)
  end

  def top_cities_by_items_shipped(limit)
    items.joins(:order_items)
         .joins('join orders on orders.id = order_items.order_id')
         .joins('join users on users.id = orders.user_id')
         .where(order_items: {fulfilled: true}, orders: {status: :shipped})
         .group('users.state, users.city')
         .select('users.state, users.city, sum(order_items.quantity) AS quantity')
         .order('quantity DESC')
         .limit(limit)
  end

  def top_users_by_money_spent(limit)
    items.joins(:order_items)
        .joins('join orders on orders.id = order_items.order_id')
        .joins('join users on users.id = orders.user_id')
        .where(order_items: {fulfilled: true})
        .group('users.id')
        .select('users.name, sum(order_items.quantity * order_items.price) AS total')
        .order('total DESC')
        .limit(limit)
  end

  def top_user_by_order_count
    items.joins(:order_items)
         .joins('join orders on orders.id = order_items.order_id')
         .joins('join users on users.id = orders.user_id')
         .where(order_items: {fulfilled: true})
         .group('users.id')
         .select('users.name, count(orders.id) AS count')
         .order('count DESC')
         .limit(1).first
  end

  def top_user_by_item_count
    items.joins(:order_items)
         .joins('join orders on orders.id = order_items.order_id')
         .joins('join users on users.id = orders.user_id')
         .where(order_items: {fulfilled: true})
         .group('users.id')
         .select('users.name, sum(order_items.quantity) AS quantity')
         .order('quantity DESC')
         .limit(1).first
  end

  def self.active_merchants
    where(role: :merchant, active: true)
  end

  def self.default_users
    where(role: :default)
  end

  def self.top_merchants_by_revenue(limit)
    merchants_sorted_by_revenue.limit(limit)
  end

  def self.merchants_sorted_by_revenue
    self.joins(:items)
        .joins('join order_items on items.id = order_items.item_id')
        .joins('join orders on orders.id = order_items.order_id')
        .where(orders: {status: :shipped}, order_items: {fulfilled: true})
        .group(:id)
        .select('users.*, sum(order_items.quantity * order_items.price) AS total')
        .order("total DESC")
  end

  def self.merchants_sorted_by_fulfillment_time(limit, order = :asc)
    self.joins(:items)
        .joins('join order_items on items.id = order_items.item_id')
        .joins('join orders on orders.id = order_items.order_id')
        .where.not(orders: {status: :cancelled})
        .where(order_items: {fulfilled: true})
        .group(:id)
        .select('users.*, avg(order_items.updated_at - order_items.created_at) AS fulfillment_time')
        .order("fulfillment_time #{order}")
        .limit(limit)
  end

  def self.top_merchants_by_fulfillment_time(limit)
    merchants_sorted_by_fulfillment_time(limit)
  end

  def self.bottom_merchants_by_fulfillment_time(limit)
    merchants_sorted_by_fulfillment_time(limit, :desc)
  end

  def self.top_user_states_by_order_count(limit)
    self.joins(:orders)
        .where(orders: {status: :shipped})
        .group(:state)
        .select('users.state, count(orders.id) AS order_count')
        .order('order_count DESC')
        .limit(limit)
  end

  def self.top_user_cities_by_order_count(limit)
    self.joins(:orders)
        .where(orders: {status: :shipped})
        .group(:state, :city)
        .select('users.city, users.state, count(orders.id) AS order_count')
        .order('order_count DESC')
        .limit(limit)
  end

  def self.fastest_fullfilled_by_state(count, state)
    selected = self.where(state: state, order_items: {fulfilled: true} )
                   .where.not(orders: {status: :cancelled})
                   .joins(orders: :items)
                   .pluck("order_items.id")
    fulfillment_time_calc_and_group(count, selected)
  end

  def self.fastest_fullfilled_by_city(count, city)
    selected = self.where(city: city, order_items: {fulfilled: true} )
                   .where.not(orders: {status: :cancelled})
                   .joins(orders: :items)
                   .pluck("order_items.id")
    fulfillment_time_calc_and_group(count, selected)
  end

  def self.fulfillment_time_calc_and_group(count, selected)
    self.joins(items: :order_items)
        .where("order_items.id": selected)
        .group(:id)
        .select('users.*, avg(order_items.updated_at - order_items.created_at) AS avg_fill_time')
        .order("avg_fill_time ASC")
        .limit(count)
  end

  def self.top_merchants_by_items_sold_between(merch_count, start_date, end_date)
    self.joins(items: {order_items: :order})
        .where.not(orders: {status: :cancelled})
        .where("order_items.created_at BETWEEN ? and ?", end_date, start_date)
        .select("users.*, SUM(order_items.quantity) as total_items")
        .group(:id)
        .order("total_items DESC")
        .limit(merch_count)
  end

  def self.top_merchants_by_non_cancelled_orders_between(merch_count, start_date, end_date)
    self.joins(items: :orders)
        .where.not(orders: {status: :cancelled})
        .where("order_items.fulfilled = ? AND order_items.created_at BETWEEN ? and ?", 'true', end_date, start_date)
        .select("users.*, sum(order_items.quantity) as total_items, count(order_items.id) as total_orders")
        .group(:id)
        .order("total_orders DESC, total_items DESC")
        .limit(merch_count)
  end

end

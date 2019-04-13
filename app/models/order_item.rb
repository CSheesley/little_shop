class OrderItem < ApplicationRecord
  belongs_to :order
  belongs_to :item
  has_one :review

  validates :price, presence: true, numericality: {
    only_integer: false,
    greater_than_or_equal_to: 0
  }
  validates :quantity, presence: true, numericality: {
    only_integer: true,
    greater_than_or_equal_to: 1
  }

  def subtotal
    quantity * price
  end

  def fulfill
    if item.inventory >= quantity && !self.fulfilled
      item.inventory -= quantity
      self.fulfilled = true
      item.save
      save
    end
  end

  def inventory_available
    item.inventory >= quantity
  end

  def reviewable?
    # order is complete - self.order.status
    # user = self.order.user
    # user has not reviewed this order item yet - self.reviews.where(user_id: user.id)nil?
  end
end

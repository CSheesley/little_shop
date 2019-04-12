class Review < ApplicationRecord
  validates_presence_of :title
  validates_presence_of :description
  validates_presence_of :rating
  validates_numericality_of :rating, greater_than_or_equal_to: 1, less_than_or_equal_to: 5, message: 'must be 1 through 5'

  belongs_to :user
  belongs_to :order_item


  def item_reviewed
    Item.find(order_item.item_id)
  end
end

class Review < ApplicationRecord
  validates_presence_of :title
  validates_presence_of :description
  validates_presence_of :rating
  validates_inclusion_of :rating, in: 1..5

  belongs_to :user
  belongs_to :order_item
end

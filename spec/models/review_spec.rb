require 'rails_helper'

RSpec.describe Review, type: :model do
  describe 'validations' do
    it { should validate_presence_of :title }
    it { should validate_presence_of :description }
    it { should validate_presence_of :rating }
  end

  describe 'relationships' do
    it { should belong_to :user }
    it { should belong_to :order_item }
  end

  describe 'instance methods' do
    context '#item_reviewed' do
      it 'returns the item which was reviewed' do

        @user = create(:user)
        @item_1 = create(:item)
        @order_1 = create(:order)
        @order_item_1 = create(:order_item, order_id: @order_1.id, item_id: @item_1.id)
        @review_1 = create(:review, user_id: @user.id, order_item_id: @order_item_1.id)

        @item_2 = create(:item)
        @order_2 = create(:order)
        @order_item_2 = create(:order_item, order_id: @order_2.id, item_id: @item_2.id)
        @review_2 = create(:review, user_id: @user.id, order_item_id: @order_item_2.id)

        expect(@review_1.item_reviewed).to eq(@item_1)
        expect(@review_2.item_reviewed).to eq(@item_2)
      end
    end
  end
end

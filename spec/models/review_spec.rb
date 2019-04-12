require 'rails_helper'

RSpec.describe Review, type: :model do
  describe 'validations' do
  end

  describe 'relationships' do
    it { should belong_to :user }
    it { should belong_to :order_item}
  end

end

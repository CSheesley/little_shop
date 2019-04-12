require 'rails_helper'

RSpec.describe 'Profiles Reviews Index Page', type: :feature do
  before :each do
    @user = create(:user)

    # create items
    # create orders
    # create order_items?
    # create reviews?

    login_as(@user)
    visit profile_reviews_path
  end

  context 'when I visit my reviews index page' do
    xit 'shows a list of all of the reviews which I have written' do

      within "#my-reviews-#{@review_1.id}" do
        expect(page).to have_content("Title: #{@review_1.title}")
        expect(page).to have_content("Description: #{@review_1.description}")
        expect(page).to have_content("Created/Updated: #{@review_1.updated_at}")
      end

      within "#my-reviews-#{@review_2.id}" do
        expect(page).to have_content("Title: #{@review_1.title}")
        expect(page).to have_content("Description: #{@review_1.description}")
        expect(page).to have_content("Created/Updated: #{@review_1.updated_at}")
      end
    end

    xit 'gives me an option to edit or delete any of my reviews' do

      within "#my-reviews-#{@review_1.id}" do
        expect(page).to have_link("Edit")
        expect(page).to have_link("Delete")
      end

      within "#my-reviews-#{@review_2.id}" do
        expect(page).to have_link("Edit")
        expect(page).to have_link("Delete")
      end
    end

    xit 'does not give me the ability to add a new review anywhere on this page' do

      expect(page).to_not have_content("Add New Review")
      expect(page).to_not have_content("New Review")
    end
  end
end

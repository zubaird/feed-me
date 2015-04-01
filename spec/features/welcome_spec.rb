require 'rails_helper'

feature "User sees welcome page" do
  scenario "User can see a list of free events" do
    visit root_path

    click_on("Find Free Food")

    

    expect(page).to have_content("Listing Free Foods")
  end



end

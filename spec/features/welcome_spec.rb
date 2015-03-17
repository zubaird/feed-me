require 'rails_helper'

feature "User sees welcome page" do
  scenario "visits home page" do

    visit root_path

    expect(page).to have_content("feed meh")

  end

end

require 'rails_helper'

feature "User sees welcome page" do
  before do
    @event_one = FoodEvent.create!(
    title:"EVENT TWO TITLE",
    date: "Tuesday, March 17, 2015",
    time: "4:00 am to 2:00 am",
    address: "582 Washington St., San Francisco, CA",
    allday: false,
    start_time: "Tuesday, March 17, 2015 4:00 PM",
    end_time: "Tuesday, March 17, 2015 2:00 AM",
    )

    @event_two = FoodEvent.create!(
    title:"Aventine’s 2015 St. Patrick’s Day Alley Block Party | SF",
    date: "Tuesday, March 17, 2015",
    time: "4:00 am to 2:00 am",
    address: "582 Washington St., San Francisco, CA",
    allday: false,
    start_time: "Tuesday, March 17, 2015 4:00 PM",
    end_time: "Tuesday, March 17, 2015 2:00 AM",
    )
  end

  scenario "User can see a list of free events" do
    visit root_path

    click_on("Find Free Food")
    save_and_open_page
    expect(page).to have_content("Listing Free Foods")
    expect(page).to have_text(@event_one.title)
    expect(page).to have_text(@event_two.title)
  end


end

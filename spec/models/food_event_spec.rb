require 'rails_helper'

def add_data
  FoodEvent.create!(
  title: "30th Annual St. Patrick’s Day Block Party | Financial District",
  date: "Tuesday, March 17, 2015",
  time: "All Day",
  address: "301 Sacramento St., San Francisco, CA",
  )
  FoodEvent.create!(
  title:"Aventine’s 2015 St. Patrick’s Day Alley Block Party | SF",
  date: "Tuesday, March 17, 2015",
  time: "4:00 am to 2:00 am",
  address: "582 Washington St., San Francisco, CA",
  )
end

describe FoodEvent do
  before do
    add_data
  end

  it "responds to title, date, time, address" do

    event = FoodEvent.first

    expect(event.title).to eq("30th Annual St. Patrick’s Day Block Party | Financial District")
    expect(event.date.to_s).to eq("2015-03-17")
    expect(event.time).to eq("All Day")
    expect(event.address).to eq("301 Sacramento St., San Francisco, CA")
  end

  describe FoodEvent, ".all" do
    it "shows all free food events" do
      all_free_food_events = FoodEvent.all
      all_free_food_events
      expect(all_free_food_events.length).to eq(2)
    end
  end

  describe FoodEvent, ".allday" do
    it "is true if .time is 'All Day'" do
      event = FoodEvent.first
      expect(event.allday).to eq(true)
    end
    it "is false if .time is not 'All Day'" do
      event = FoodEvent.last
      expect(event.allday).to eq(false)
    end
  end


  describe FoodEvent, ".start" do
    it "saves the event start time" do
      event = FoodEvent.first
      p "*" * 80
      p event.start
      p event.start.class
      expect(event.start.to_s).to eq("2015-03-29 00:00:00 -0700")
    end
  end

  describe FoodEvent, ".end" do
    xit "saves the event end time" do
      event = FoodEvent.first
      expect(event.end).to eq("11:59 P.M.")
    end
  end
end

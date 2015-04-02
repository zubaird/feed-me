require 'rails_helper'

describe FoodEvent do
  include ActionView::Helpers::DateHelper

  let(:event_one){
    FoodEvent.create!(
    title: "30th Annual St. Patrick’s Day Block Party | Financial District",
    date: "Tuesday, March 17, 2015",
    time: "All Day",
    address: "301 Sacramento St., San Francisco, CA",
    allday: true,
    start_time: "Tuesday, March 17, 2015 12:00 AM",
    end_time: "Tuesday, March 17, 2015 11:59 PM",
    )
  }

  let(:event_two){
    FoodEvent.create!(
    title:"Aventine’s 2015 St. Patrick’s Day Alley Block Party | SF",
    date: "Tuesday, March 17, 2015",
    time: "4:00 am to 2:00 am",
    address: "582 Washington St., San Francisco, CA",
    allday: false,
    start_time: "Tuesday, March 17, 2015 4:00 PM",
    end_time: "Tuesday, March 17, 2015 2:00 AM",
    )
  }

  it "responds to title, date, time, address" do
    expect(event_one.title).to eq("30th Annual St. Patrick’s Day Block Party | Financial District")
    expect(event_one.date.to_s).to eq("2015-03-17")
    expect(event_one.time).to eq("All Day")
    expect(event_one.address).to eq("301 Sacramento St., San Francisco, CA")
    expect(event_one.allday).to eq(true)
    expect(event_one.start_time).to eq("Tuesday, March 17, 2015 12:00 AM")
    expect(event_one.end_time).to eq("Tuesday, March 17, 2015 11:59 PM")
  end

  describe "blank fields" do
    it "does not allow title to be blank" do
      expect(event_one.update(title: "")).to eq(false)
    end

    it "does not allow date to be blank" do
      expect(event_one.update(date: "")).to eq(false)
    end

    it "does not allow time to be blank" do
      expect(event_one.update(time: "")).to eq(false)
    end

    it "does not allow address to be blank" do
      expect(event_one.update(address: "")).to eq(false)
    end


    it "does not allow start_time to be blank" do
      expect(event_one.update(start_time: "")).to eq(false)
    end

    it "does not allow end_time to be blank" do
      expect(event_one.update(end_time: "")).to eq(false)
    end
  end

  describe "duplicate values" do
    it "does not save duplicate values" do

      original_event = FoodEvent.create(
      title:"Aventine’s 2015 St. Patrick’s Day Alley Block Party | SF",
      date: "Tuesday, March 17, 2015",
      time: "4:00 am to 2:00 am",
      address: "582 Washington St., San Francisco, CA",
      allday: false,
      start_time: "Tuesday, March 17, 2015 4:00 PM",
      end_time: "Tuesday, March 17, 2015 2:00 AM",
      )

      duplicate_event = FoodEvent.new(
      title:"Aventine’s 2015 St. Patrick’s Day Alley Block Party | SF",
      date: "Tuesday, March 17, 2015",
      time: "4:00 am to 2:00 am",
      address: "582 Washington St., San Francisco, CA",
      allday: false,
      start_time: "Tuesday, March 17, 2015 4:00 PM",
      end_time: "Tuesday, March 17, 2015 2:00 AM",
      )

      expect(duplicate_event.save).to eq(false)
    end
  end

  describe ".time_from_now" do
    describe "when the event is in the future" do
      it "shows how long from now the event will begin" do
        new_start_time = Time.now + 2000
        event_one.update(start_time: new_start_time)

        expect(event_one.time_from_now).to eq("33 minutes")
      end
    end
    describe "when the event has already past" do
      it "it returns how long ago the event was over" do
        new_start_time = Time.now - 2000
        event_one.update(start_time: new_start_time)

        expect(event_one.time_from_now).to eq("-33 minutes")
      end
    end
  end

end

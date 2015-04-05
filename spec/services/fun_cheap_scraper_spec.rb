require 'rails_helper'
require 'nokogiri'
require 'rest_client'
require 'pry'
require_relative 'event_parser_spec'

describe FunCheapScraper do

  # it_behaves_like 'event_parser'

  let(:free_events) {[
    {
      title: "30th Annual St. Patrick’s Day Block Party | Financial District",
      date: "Tuesday, March 17, 2015",
      time: "All Day",
      address: "301 Sacramento St., San Francisco, CA",
      image_url: "http://cdn.funcheap.com/wp-content/uploads/2012/03/st-patricks-day-royal-exchange1-250x166.jpg",
      allday: true,
      start_time: "Tuesday, March 17, 2015 12:00 AM",
      end_time: "Tuesday, March 17, 2015 11:59 PM",
    },
    {
      title:"Aventine’s 2015 St. Patrick’s Day Alley Block Party | SF",
      date: "Tuesday, March 17, 2015",
      time: "4:00 pm to 2:00 am",
      address: "582 Washington St., San Francisco, CA",
      image_url: "http://cdn.funcheap.com/wp-content/uploads/2011/03/stpatsparty-250x167.jpg",
      allday: false,
      start_time: "Tuesday, March 17, 2015 4:00 PM",
      end_time: "Tuesday, March 17, 2015 2:00 AM",
    },
    ]}


    before do

      @food_scraper = FunCheapScraper.new(ENV.fetch('URL'))

      @titles = [
        "30th Annual St. Patrick",
        "Aventine",
        "5th Annual Irish Caroling Extravaganza | Union Square",
        "St. Patrick&#8217;s Day Movie &#038; Cocktail Night | SF",
      ].join

      @output = []
    end

    it "is a working document" do
      expect(@food_scraper.document_usable?).to eq(true)
    end

    it "returns all the titles" do
      response = [
        "30th Annual St. Patrick’s Day Block Party | Financial District",
        "Aventine’s 2015 St. Patrick’s Day Alley Block Party | SF",
        "5th Annual Irish Caroling Extravaganza | Union Square",
        "St. Patrick’s Day Movie & Cocktail Night | SF",
      ]
      expect(@food_scraper.titles).to eq response
    end

    it "returns the date of the events" do
      response = [
        "Tuesday, March 17",
        "Tuesday, March 17",
        "Tuesday, March 17",
        "Tuesday, March 17",
      ]
      expect(@food_scraper.event_dates).to eq response
    end

    it "returns the time of the events" do
      response = [
        "All Day",
        "4:00 pm",
        "5:00 pm",
        "5:00 pm",
      ]
      expect(@food_scraper.event_times).to eq response
    end

    it "returns the cost of the events" do
      response = [
        "FREE",
        "FREE**21+",
        "FREE",
        "FREE**Free, but an RSVP is required.",
      ]
      expect(@food_scraper.event_costs).to eq response
    end

    it "returns the venue of the events" do
      response = [
        "The Royal Exchange",
        "Taverna Aventine",
        "Union Square Park",
        "Betabrand",
      ]
      expect(@food_scraper.event_venues).to eq response
    end

    it "returns the event show pages" do
      response = [
        "http://sf.funcheap.com/st-patricks-day-block-party-financial-district/",
        "http://sf.funcheap.com/aventines-st-patricks-day-alley-block-party-sf/",
        "http://sf.funcheap.com/annual-irish-caroling-extravaganza-union-square/",
        "http://sf.funcheap.com/st-patricks-day-movie-cocktail-night-sf/",
      ]
      expect(@food_scraper.event_show_page_urls).to eq response
    end

    it 'visits the show pages' do

      @food_scraper.visit_show_pages.each do |page|
        @output << page.class.to_s
      end


      result = [
        "Nokogiri::HTML::Document",
        "Nokogiri::HTML::Document",
        "Nokogiri::HTML::Document",
        "Nokogiri::HTML::Document",
      ]

      expect(@output).to eq result
    end

    it "gets the show page descriptions" do
      result = ["The Royal Exchange will throw their annual block party with traditional Irish fare, live music, and plenty of Guinness on St. Patrick’s Day proper, Tuesday, March 17, 2015.The 2015 Block Party begins at 3 pm and around 5 pm, the live music typically kicks off with party band Wonderbread 5 on Front between California and Sacramento.The Royal will once again be serving green beer through a to-go window situated right in the middle of the party.When you get hungry, there will be a special menu waiting for you including Corned Beef and Cabbage, Shepherd’s Pie and Irish Stew (for purchase).St. Patrick’s Day Block Party\nTuesday, March 17, 2015 | 3pm ’til 11pm-ish\nFront St. btwn California and Sacramento\nFREEThis block party is free, so wear your green and get ready to party in the streets.Photo credit: skressdesign.comSHARE THIS POST\r\n\t\t\t\t\t\t\r\n\t\t\t\t\t\t\r\n\t\t\t\t\t\t\r\n\t\t\t\t\t", "Aventine hosts their annual St. Patrick’s Day Alley block party in the Financial District where you can expect to get a good buzz on with about 1,500 people in the alley, DJs, beer and food.7th Annual Aventine’s St. Patrick’s Day Alley Block Party\nTuesday, March 17, 2015 | 4 pm to 2 am\nHotaling Street (btwn Washington/ Jackson & Montgomery/Sansome)\nFREE, but an RSVP is required.The first 100 people who RSVP will receive a VIP Fast Pass guaranteeing no line and no wait.This indoor and outdoor event will include: live DJ performances, Red Sauce Meatballs food truck, drink specials, a champagne bar, and special live music performance.SHARE THIS POST\r\n\t\t\t\t\t\t\r\n\t\t\t\t\t\t\r\n\t\t\t\t\t\t\r\n\t\t\t\t\t", "Why leave caroling just to Santa? Every year, the “Jerk Church” takes to the streets of San Francisco for Irish Caroling on St. Patrick’s Day armed only with their instruments, voices and devilish sparkles in their eyes.On Tuesday, March 17, 2015, they take over the streets once again… but we don’t have the exact time or details just yet! We’ll update this page as soon as we find out more, but here is what went down in 2014:They start in Union Square at 5 pm (as is their tradition) and then take to the streets and bars of SF to serenade the revelers.Jerk Church is a creative musical learning community for musicians and non-musicians alike. They gather each Sunday to break bread, share a cup and a song.SHARE THIS POST\r\n\t\t\t\t\t\t\r\n\t\t\t\t\t\t\r\n\t\t\t\t\t\t\r\n\t\t\t\t\t", "Stop by the Betabrand HQ for a St. Patrick’s Day Party to enjoy an Irish movie, some bourbon cocktails and a funny themed photo booth from 5-9 pm on March 17, 2015.Free, but an RSVP is required.Catch a screening of “Darby O’Gill and the Little People,” starring noted non-Irishman Sean Connery, from 5:30-7:30 pm, plus more shenanigans.Dance a dance of shamrock-soaked enchantment with bourbon cocktails mixed by the inventors of Caged Heat (we think these are complimentary, but bring a few bucks just in case), then get your picture taken in their golden shower (of coins), and show your friends you truly found the end of the rainbow.SHARE THIS POST\r\n\t\t\t\t\t\t\r\n\t\t\t\t\t\t\r\n\t\t\t\t\t\t\r\n\t\t\t\t\t"]

      expect(@food_scraper.show_page_descriptions).to eq result
    end

    it "shows events that might have food" do
      result = ["The Royal Exchange will throw their annual block party with traditional Irish fare, live music, and plenty of Guinness on St. Patrick’s Day proper, Tuesday, March 17, 2015.The 2015 Block Party begins at 3 pm and around 5 pm, the live music typically kicks off with party band Wonderbread 5 on Front between California and Sacramento.The Royal will once again be serving green beer through a to-go window situated right in the middle of the party.When you get hungry, there will be a special menu waiting for you including Corned Beef and Cabbage, Shepherd’s Pie and Irish Stew (for purchase).St. Patrick’s Day Block Party\nTuesday, March 17, 2015 | 3pm ’til 11pm-ish\nFront St. btwn California and Sacramento\nFREEThis block party is free, so wear your green and get ready to party in the streets.Photo credit: skressdesign.comSHARE THIS POST\r\n\t\t\t\t\t\t\r\n\t\t\t\t\t\t\r\n\t\t\t\t\t\t\r\n\t\t\t\t\t", "Aventine hosts their annual St. Patrick’s Day Alley block party in the Financial District where you can expect to get a good buzz on with about 1,500 people in the alley, DJs, beer and food.7th Annual Aventine’s St. Patrick’s Day Alley Block Party\nTuesday, March 17, 2015 | 4 pm to 2 am\nHotaling Street (btwn Washington/ Jackson & Montgomery/Sansome)\nFREE, but an RSVP is required.The first 100 people who RSVP will receive a VIP Fast Pass guaranteeing no line and no wait.This indoor and outdoor event will include: live DJ performances, Red Sauce Meatballs food truck, drink specials, a champagne bar, and special live music performance.SHARE THIS POST\r\n\t\t\t\t\t\t\r\n\t\t\t\t\t\t\r\n\t\t\t\t\t\t\r\n\t\t\t\t\t"]

      expect(@food_scraper.show_events_with_food.length).to eq result.length
    end

    it "returns the event day, time, cost, and venue" do

      response = [
        {
          title: "30th Annual St. Patrick’s Day Block Party | Financial District",
          date: "Tuesday, March 17",
          time: "All Day",
          cost: "FREE",
          venue: "The Royal Exchange",
        },
        {
          title:"Aventine’s 2015 St. Patrick’s Day Alley Block Party | SF",
          date: "Tuesday, March 17",
          time: "4:00 pm",
          cost: "FREE**21+",
          venue: "Taverna Aventine",
        },
        {
          title: "5th Annual Irish Caroling Extravaganza | Union Square",
          date: "Tuesday, March 17",
          time: "5:00 pm",
          cost: "FREE",
          venue: "Union Square Park",
        },
        {
          title: "St. Patrick’s Day Movie & Cocktail Night | SF",
          date: "Tuesday, March 17",
          time: "5:00 pm",
          cost: "FREE**Free, but an RSVP is required.",
          venue: "Betabrand",
        },
      ]

      expect(@food_scraper.event_details).to eq response

    end

    it "returns the free event date, time, cost, title, address, allday, start, end" do
      expect(@food_scraper.free_food_event_details).to eq free_events
    end

    it "saves free events to FoodEvent and does not raise and error" do
      expect(@food_scraper.store_free_events).to eq free_events
    end

  end

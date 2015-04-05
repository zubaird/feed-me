require 'nokogiri'
require 'rest_client'
require 'active_support/core_ext/hash/conversions'

class FoodCrawler

  def crawl_it(url)
    get_url = RestClient.get url
    doc = Nokogiri::HTML(get_url)
  end

end


class FunCheapScraper

  def initialize(base_url)
    @crawler = FoodCrawler.new.crawl_it(base_url)
    @events = @crawler.css("div.tanbox div.meta")
    @url = @crawler.css("div.tanbox span")
  end

  def store_free_events
    free_food_event_details.each do |event|
      p event
      add_event = FoodEvent.new(event)
      if add_event.save
        "success"
        p add_event
      else
        raise "ERROR ON SAVE: #{add_event.errors.each {|error| p error }}"
      end
    end
  end

  def document_usable?
    @crawler.class == Nokogiri::HTML::Document
  end

  def visit_show_pages
    show_pages = []
    event_show_page_urls.each do |url|
      show_page = FoodCrawler.new.crawl_it(url)
      show_pages << show_page
    end
    show_pages
  end

  def show_page_descriptions
    descriptions = []
    visit_show_pages.each do |show_page|
      descriptions << show_page.css("div.entry.clearfloat p").text
    end
    descriptions
  end

  def show_events_with_food
    food_events = []
    visit_show_pages.each do |show_page|
      if has_food_on(show_page.css("div.entry.clearfloat p").text)
        food_events << show_page
      end
    end
    food_events
  end

  def has_food_on(page)
    # => create an array instead of regex
    food_match = /menu|lunch|dinner|breakfast|drink|cabbage|cheese|wine|food|cheese|chocolate|dessert|snacks|drink|pizza/i
    no_food_match = /(no food)/i
    page.match(food_match) && !page.match(no_food_match)
  end


  def free_food_event_details
    details = []

    show_events_with_food.each do |event|
      details << {
        title: get_title_for(event),
        date: get_date_for(event),
        time: get_time_for(event),
        address: get_address_for(event),
        image_url: get_image_url_for(event),
        allday: get_allday_for(event),
        start_time: get_start_for(event),
        end_time: get_end_for(event),
      }
    end
    details
  end
  # //*[@class="post"]/div[2]/div[2]/p[1]/strong[1]/a/img
  # #post-191487 > div.entry.clearfloat > div.event-series.clearfloat > p:nth-child(1) > strong:nth-child(1) > a > img
  # #post-417452 > div.entry.clearfloat > div.event-series.clearfloat > p:nth-child(1) > img
  # //*[@id="post-417452"]/div[2]/div[2]/p[1]/img
  def get_image_url_for(event)
    pp event.css("div.post > div.entry.clearfloat img")[0].attributes["src"].value
  end

  def get_allday_for(event)
    if get_time_for(event) == "All Day"
      true
    else
      false
    end
  end

  def get_start_for(event)
    if get_allday_for(event) == false
      start_time = get_time_for(event).downcase.match(/.*( pm)|( am)/).to_s.upcase
      "#{get_date_for(event)} #{start_time}"
    else
      "#{get_date_for(event)} 12:00 AM"
    end
  end

  def get_end_for(event)
    if get_allday_for(event) == false
      end_time = get_time_for(event).downcase.match(/ \d.*/).to_s.strip.upcase
      "#{get_date_for(event)} #{end_time}"
    else
      "#{get_date_for(event)} 11:59 PM"
    end
  end

  def get_date_for(event)
    event.css("#stats > span.left > a").text
  end

  def get_title_for(event)
    p event.css("div.post > h1").text
  end

  def get_time_for(event)
    event.xpath("//*[@id='stats']/span[1]/span/text()[1]").text.gsub("-","").strip
  end

  def get_address_for(event)

    address_search = event.css("div.post > div.entry.clearfloat > div > b")

    if address_search.text == "VenueAddress"
      address_unformatted = address_search[1].parent.children.text
    elsif address_search.text == "Address"
      address_unformatted = address_search.text
    end

    formatted_address = address_unformatted.gsub("Address:", "").strip
    p formatted_address
  end

  def titles
    titles = []
    events = @crawler.css("div.tanbox span.title a")
    events.each do |event|
      titles << event.content
    end
    titles
  end

  def event_dates
    event_dates_list = []
    @events.each do |event|
      event.children.text.gsub("\n","").gsub("\t","").gsub("\r","")
      details = event.children.text.gsub("\n","").gsub("\t","").gsub("\r","")
      event_date = details.split(/\u0096/)[0].strip
      event_dates_list << event_date
    end
    event_dates_list
  end

  def event_times
    time_regex = %r"(.*?)[^\|]+"
    event_times_list = []
    @events.each do |event|
      details = event.children.text.gsub("\n","").gsub("\t","").gsub("\r","")
      time_string = details.match(time_regex).to_s
      event_time = time_string[time_string.length - 9..time_string.length].strip
      event_times_list << event_time
    end
    event_times_list
  end

  def event_costs
    event_costs_list = []
    @events.each do |event|
      details = event.children.text.gsub("\n","").gsub("\t","").gsub("\r","")
      cost_string = details.split("|")[1].gsub("Cost:","").strip
      event_costs_list << cost_string
    end
    event_costs_list
  end

  def event_venues
    event_venues_list = []
    @events.each do |event|
      details = event.children.text.gsub("\n","").gsub("\t","").gsub("\r","")
      venues_string = details.split("|")[2].strip unless details == nil
      event_venues_list << venues_string
    end
    event_venues_list
  end

  def event_show_page_urls
    event_show_pages_list = []
    @url.css("a").each do |link_tag|
      if link_tag.attribute("href")
        event_show_pages_list << link_tag.attribute("href").value
      end
    end
    event_show_pages_list
  end

  def event_details
    details = []
    for i in 0..@events.length-1
      details << {
        title: titles[i],
        date: event_dates[i],
        time: event_times[i],
        cost: event_costs[i],
        venue: event_venues[i],
      }
      i += 1
    end
    details
  end

end

require 'rest_client'

class EventbriteClient
  API_ENDPOINT =
      "https://www.eventbriteapi.com/v3/events/search/?q=cheese&token=#{ENV['EVENTBRITE_TOKEN']}"

  def get_events(location:)
    pp ENV
    p ENV['EVENTBRITE_TOKEN']
    p RestClient.get(API_ENDPOINT)
  end
end

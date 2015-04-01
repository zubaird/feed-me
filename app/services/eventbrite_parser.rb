require 'json'

class EventbriteParser
  def initialize(api_client)
    @api_client = api_client
  end

  def get_events_with_free_food
    JSON.parse(@api_client.get_events)
  end



end

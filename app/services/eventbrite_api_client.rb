# require 'rest_client'
#
# class EventbriteClient
#   API_ENDPOINT =
#     "https://www.eventbriteapi.com/v3/events/search/?token=#{ENV['EVENTBRITE_TOKEN']}"
#
#   def get_events(location:)
#     p ENV["EVENTBRITE_TOKEN"]
#     RestClient.get(API_ENDPOINT, {
#       # token: ENV["EVENTBRITE_TOKEN"],
#       location: location,
#       keywords: "free food"
#       })
#   end
#
# end

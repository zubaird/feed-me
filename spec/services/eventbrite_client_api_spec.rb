# require 'rails_helper'
# require_relative '../../app/services/eventbrite_api_client'
# require 'vcr'
#
# describe EventbriteClient do
#
#   around do |example|
#     VCR.use_cassette('event_brite') do
#       example.run
#     end
#   end
#
#   it 'returns the list of events in SF that are free' do
#     client = EventbriteClient.new
#
#     response = client.get_events(location: 'San Francisco')
#
#     pp response.to_json
#
#     expect(response).to eq({})
#   end
# end

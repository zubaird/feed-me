require_relative '../../app/services/eventbrite_parser'
require_relative 'event_parser_spec'
require 'json'

describe EventbriteParser do
  it_behaves_like 'event_parser'

  # let(:api_client) { double(get_events: response.to_json) }
  # let(:response) {
  #   {
  #     title: 'blah'
  #   }
  # }

  # before do
  #   allow(eventbrite_api_client).to receive(:get_events).and_return(
  #     response.to_json
  #   )
  # end

  let(:input_hash) { {data: 'foods'} }

  it 'can get event information from the eventbrite api' do
    expect(
      EventbriteParser.new(eventbrite_api_client).get_events_with_free_food
    ).to change(Event, :count).by(1)
  end
end


response = api_client.get_stuff
# munging here
event_brite_parser.parse(response)


task :whatever do
  some_hash = event_brite_parser.parse(response)
  # Event.create(some_hash)
end

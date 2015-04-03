namespace :feedme do
  desc "TODO"
  task funcheap: :environment do
    FunCheapScraper.new("http://sf.funcheap.com/free-events/").store_free_events
    FunCheapScraper.new("http://sf.funcheap.com/free-events/page/2/").store_free_events
    FunCheapScraper.new("http://sf.funcheap.com/free-events/page/3/").store_free_events
  end

end

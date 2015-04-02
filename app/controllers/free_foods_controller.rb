class FreeFoodsController < ApplicationController

  def index
    @events = FoodEvent.all
  end

end

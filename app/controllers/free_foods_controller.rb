class FreeFoodsController < ApplicationController

  def index
    @events = FoodEvent.all
    @event = FoodEvent.new

    respond_to do |format|
      format.html
      format.json { render json: @events }  # respond with the created JSON object
    end
  end

  def create
    FoodEvent.create!(event_params)
    redirect_to free_foods_path
  end


  private

  def event_params
    params.require(:food_event).permit(
      :title,
      :date,
      :address,
      :allday,
      :lat,
      :lng,
      :start_time,
      :end_time,
      :image_url,
    )
  end

end
#
# "food_event"=>{"title"=>"",
# "date"=>"",
# "address"=>"",
# "allday"=>"0",
# "start_time"=>"",
# "end_time"=>""},
# "commit"=>"Create Food event"}

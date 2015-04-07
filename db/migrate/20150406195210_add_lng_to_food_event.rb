class AddLngToFoodEvent < ActiveRecord::Migration
  def change
    add_column :food_events, :lng, :float
  end
end

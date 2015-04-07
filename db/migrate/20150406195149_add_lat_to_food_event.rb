class AddLatToFoodEvent < ActiveRecord::Migration
  def change
    add_column :food_events, :lat, :float
  end
end

class AddImageUrlToFoodEvents < ActiveRecord::Migration
  def change
    add_column :food_events, :image_url, :string
  end
end

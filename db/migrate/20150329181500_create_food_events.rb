class CreateFoodEvents < ActiveRecord::Migration
  def change
    create_table :food_events do |t|
      t.string :title
      t.date :date
      t.string :time
      t.string :address
      t.boolean :allday
      t.time :start
      t.time :end
      t.timestamp
    end
  end
end

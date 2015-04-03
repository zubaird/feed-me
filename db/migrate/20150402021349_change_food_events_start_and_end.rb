class ChangeFoodEventsStartAndEnd < ActiveRecord::Migration
  def change
    change_column :food_events, :start, :string
    change_column :food_events, :end, :string
    rename_column :food_events, :start, :start_time
    rename_column :food_events, :end, :end_time
  end
end

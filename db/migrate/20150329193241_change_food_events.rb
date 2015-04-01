class ChangeFoodEvents < ActiveRecord::Migration
  def change
    change_column :food_events, :allday, :boolean, :default=> false
  end
end

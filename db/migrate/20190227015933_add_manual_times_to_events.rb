class AddManualTimesToEvents < ActiveRecord::Migration[5.1]
  def change
    add_column :events, :occurance_year, :integer, limit: 5
    add_column :events, :occurance_day, :integer, limit: 1
    add_column :events, :occurance_month, :integer, limit: 1
  end
end

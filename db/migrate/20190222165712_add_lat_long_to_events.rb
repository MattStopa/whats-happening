class AddLatLongToEvents < ActiveRecord::Migration[5.1]
  def change
    add_column :events, :lat, :decimal, precision: 10, scale: 8
    add_column :events, :lng, :decimal, precision: 11, scale: 8
    add_column :events, :address, :string
  end
end

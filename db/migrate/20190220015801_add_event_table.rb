class AddEventTable < ActiveRecord::Migration[5.1]
  def change
    create_table :events do |t|
      t.string :title, null: false
      t.string :description, null: false
      t.json :coordinates
      t.timestamp :event_occured
      t.json :tags
    end
  end
end

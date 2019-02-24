class AddTagsTables < ActiveRecord::Migration[5.1]
  def change
    create_table :tags do |t|
      t.string :title, null: false
      t.string :description, null: false
      t.json :meta_data
      t.datetime :created_at, null: false
      t.datetime :updated_at, null: false
    end
  end
end

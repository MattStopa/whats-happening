class AddTagListRelation < ActiveRecord::Migration[5.1]
  def change
    create_table :tags_list do |t|
      t.integer :event_id, null: false
      t.integer :tag_id, null: false
      t.datetime :created_at, null: false
      t.datetime :updated_at, null: false
    end
  end
end

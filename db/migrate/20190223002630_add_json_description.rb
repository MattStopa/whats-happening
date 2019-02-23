class AddJsonDescription < ActiveRecord::Migration[5.1]
  def change
    add_column :events, :json_description, :json
  end
end

class AddColumnToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :pluggy_item_id, :string
    add_column :users, :pluggy_last_update, :date
  end
end

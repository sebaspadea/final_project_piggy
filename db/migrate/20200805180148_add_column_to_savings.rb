class AddColumnToSavings < ActiveRecord::Migration[6.0]
  def change
    add_column :savings, :status, :string
  end
end

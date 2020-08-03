class CreateExpenses < ActiveRecord::Migration[6.0]
  def change
    create_table :expenses do |t|
      t.references :user, null: false, foreign_key: true
      t.references :saving, null: false, foreign_key: true
      t.string :category
      t.integer :amount
      t.text :description

      t.timestamps
    end
  end
end

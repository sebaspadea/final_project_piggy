class CreateSavings < ActiveRecord::Migration[6.0]
  def change
    create_table :savings do |t|
      t.references :user, null: false, foreign_key: true
      t.integer :total_amount
      t.integer :goal
      t.text :goal_description

      t.timestamps
    end
  end
end

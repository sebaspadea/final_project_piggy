class ChangeSavingReferences < ActiveRecord::Migration[6.0]
  def change
    change_column_null :expenses, :saving_id, true
  end
end

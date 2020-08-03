class Expense < ApplicationRecord
  belongs_to :user
  belongs_to :saving, optional: true
end

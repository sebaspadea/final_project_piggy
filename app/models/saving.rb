class Saving < ApplicationRecord
  belongs_to :user
  STATUS = %w(Open Broken)
  validates :status, inclusion: { in: STATUS }
  validates :goal, numericality: { only_integer: true }
  validates :goal_description, length: { maximum: 50 }

  def progress
    ((total_amount / goal.to_f) * 100).round(2)
  end
end

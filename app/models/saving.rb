class Saving < ApplicationRecord
  belongs_to :user
  validates :goal, numericality: { only_integer: true }
  validates :goal_description, length: { maximum: 20 }

end

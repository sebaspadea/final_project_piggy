class Expense < ApplicationRecord
  belongs_to :user
  belongs_to :saving, optional: true
  CATEGORY = %w(Gastronomia Servicios Entretenimiento Transporte Otros)
  validates :category, inclusion: { in: CATEGORY }
  validates :amount, presence: true, numericality: { only_integer: true }
  validates :description, length: { maximum: 50 }
end

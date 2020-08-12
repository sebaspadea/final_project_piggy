class Expense < ApplicationRecord
  belongs_to :user
  belongs_to :saving, optional: true
  CATEGORY = ["Entretenimiento", "Gastronomia", "Otros", "Servicios", "Tarjeta de Crédito", "Transporte"]
  validates :category, inclusion: { in: CATEGORY }
  validates :amount, presence: true, numericality: { only_integer: true }
  validates :description, length: { maximum: 50 }
end

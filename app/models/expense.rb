class Expense < ApplicationRecord
  belongs_to :user
  belongs_to :saving, optional: true
  CATEGORY = ["Gastronomia", "Servicios", "Entretenimiento", "Transporte", "Tarjeta de Crédito", "Otros"]
  validates :category, inclusion: { in: CATEGORY }
  validates :amount, presence: true, numericality: { only_integer: true }
  validates :description, length: { maximum: 50 }
end

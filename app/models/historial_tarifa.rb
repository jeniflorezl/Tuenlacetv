class HistorialTarifa < ApplicationRecord
  belongs_to :tarifa
  belongs_to :zona
  belongs_to :concepto
  belongs_to :plan
  belongs_to :usuario

  validates :tarifa, :zona, :concepto, :plan, :valor, :fechainicio, :fechavence,
  :usuario, presence: true #obligatorio
end

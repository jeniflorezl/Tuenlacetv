class Concepto < ApplicationRecord
  belongs_to :servicio
  has_many :tarifas
  validates :servicio_id, :codigo, :nombre, :porcentajeIva, :abreviatura, :operacion,
  :usuario, presence: true #obligatorio
end

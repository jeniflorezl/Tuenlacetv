class Concepto < ApplicationRecord
  belongs_to :servicio
  validates :servicio_id, :codigo, :nombre, :porcentajeIva, :abreviatura, :operacion,
  :usuario, presence: true #obligatorio
end

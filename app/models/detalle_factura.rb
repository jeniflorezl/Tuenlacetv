class DetalleFactura < ApplicationRecord
  belongs_to :concepto
  belongs_to :usuario

  validates :concepto, :valor, :porcentajeIva, :iva, :operacion, :usuario, presence: true #obligatorio
end

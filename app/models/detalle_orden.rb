class DetalleOrden < ApplicationRecord
  belongs_to :concepto
  belongs_to :articulo
  belongs_to :usuario

  validates :concepto, :valor, :porcentajeIva, :iva, :costo, :usuario, presence: true #obligatorio
end

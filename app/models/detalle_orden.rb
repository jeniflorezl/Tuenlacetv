class DetalleOrden < ApplicationRecord
  belongs_to :concepto
  belongs_to :articulo
  belongs_to :usuario
end

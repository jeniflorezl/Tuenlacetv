class DetalleOrden < ApplicationRecord
  belongs_to :orden, :foreign_key => [:concepto_id, :nrorden]
  belongs_to :concepto
  belongs_to :articulo
  belongs_to :usuario
end

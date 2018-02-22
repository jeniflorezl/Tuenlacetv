class DetalleOrden < ApplicationRecord
  belongs_to :orden
  belongs_to :articulo
end

class FacturaOrden < ApplicationRecord
  belongs_to :facturacion
  belongs_to :orden
end

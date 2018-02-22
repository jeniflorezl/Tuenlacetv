class DetalleFactura < ApplicationRecord
  belongs_to :facturacion
  belongs_to :concepto
end

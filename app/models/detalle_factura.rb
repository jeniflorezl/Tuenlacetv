class DetalleFactura < ApplicationRecord
  belongs_to :concepto
  belongs_to :usuario
end

class DetalleFactura < ApplicationRecord
  belongs_to :facturacion, :foreign_key => [:documento_id, :prefijo, :nrofact]
  belongs_to :concepto
  belongs_to :usuario
end

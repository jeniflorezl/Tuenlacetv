class Anticipo < ApplicationRecord
  belongs_to :senal
  belongs_to :facturacion
  belongs_to :pago
end

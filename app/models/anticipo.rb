class Anticipo < ApplicationRecord
  belongs_to :entidad
  belongs_to :facturacion
  belongs_to :pago
end

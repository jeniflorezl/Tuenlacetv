class Abono < ApplicationRecord
  belongs_to :pago, :foreign_key => [:documento_id, :nropago]
  belongs_to :documento
  belongs_to :concepto
  belongs_to :usuario
end

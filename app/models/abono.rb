class Abono < ApplicationRecord
  belongs_to :documento
  belongs_to :concepto
  belongs_to :usuario
end

class Abono < ApplicationRecord
  belongs_to :concepto
  belongs_to :usuario

  validates :concepto, :fechabono, :saldo, :abono, :usuario, presence: true #obligatorio
end

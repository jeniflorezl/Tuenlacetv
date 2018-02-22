class Tarifa < ApplicationRecord
  belongs_to :zona
  belongs_to :concepto
  belongs_to :plan
  belongs_to :estado
  belongs_to :usuario

  validates :zona, :concepto, :plan, :valor, :estado, :usuario, presence: true #obligatorio
end

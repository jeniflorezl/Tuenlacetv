class Tarifa < ApplicationRecord
  belongs_to :zona
  belongs_to :concepto
  belongs_to :plan
  validates :zona_id, :concepto_id, :plan_id, :valor, :estado, :usuario, presence: true #obligatorio
end

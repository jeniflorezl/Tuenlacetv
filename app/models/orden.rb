class Orden < ApplicationRecord
  belongs_to :senal
  belongs_to :concepto
  belongs_to :estado
  belongs_to :usuario

  validates :senal, :concepto, :nrorden, :estado, presence: true #obligatorio
end

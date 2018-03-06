class Orden < ApplicationRecord
  belongs_to :senal
  belongs_to :concepto
  belongs_to :estado

  validates :senal, :concepto, :estado, presence: true #obligatorio
end

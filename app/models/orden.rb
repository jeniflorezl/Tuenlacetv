class Orden < ApplicationRecord
  belongs_to :senal
  belongs_to :concepto
  belongs_to :estado
  belongs_to :entidad

  validates :senal, :concepto, :estado, :entidad, presence: true #obligatorio
end

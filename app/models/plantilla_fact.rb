class PlantillaFact < ApplicationRecord
  belongs_to :entidad
  belongs_to :concepto
  belongs_to :estado
  belongs_to :tarifa
  belongs_to :usuario

  validates :entidad, :concepto, :estado, :tarifa, :usuario, presence: true #obligatorio
end

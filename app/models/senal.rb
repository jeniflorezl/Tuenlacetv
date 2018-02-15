class Senal < ApplicationRecord
  belongs_to :entidad
  belongs_to :barrio
  belongs_to :zona
  belongs_to :tipo_instalacion
  belongs_to :tecnologia
  belongs_to :entidad
  belongs_to :servicio
  belongs_to :estado
  validates :contrato, :servicio, :barrio, :zona, :estado, :fechacontrato,  :tipo_instalacion, :tecnologia, 
  :usuario, presence: true #obligatorio
end

class Senal < ApplicationRecord
  belongs_to :entidad
  belongs_to :barrio
  belongs_to :zona
  belongs_to :tipo_instalacion
  belongs_to :tecnologia
  belongs_to :entidad
  validates :contrato, :barrio_id, :zona_id, :estado, :fechacontrato, :vendedor_id, 
  :tipo_instalacion_id, :tecnologia_id, :tiposervicio, :areainstalacion, :usuario, presence: true #obligatorio
end

class Senal < ApplicationRecord
  belongs_to :entidad
  belongs_to :servicio
  belongs_to :barrio
  belongs_to :zona
  belongs_to :estado
  belongs_to :tipo_instalacion
  belongs_to :tecnologia
  belongs_to :entidad
  belongs_to :usuario

  before_save :uppercase

  validates :entidad, :servicio, :contrato, :direccion, :telefono1, :barrio, :zona, :estado, 
  :fechacontrato,  :tipo_instalacion, :tecnologia, :tiposervicio, :usuario, presence: true #obligatorio

  def uppercase
    self.direccion.upcase!
    self.urbanizacion.upcase!
    self.torre.upcase!
    self.apto.upcase!
    self.vivienda.upcase!
    self.tiposervicio.upcase!
    self.areainstalacion.upcase!
  end
end

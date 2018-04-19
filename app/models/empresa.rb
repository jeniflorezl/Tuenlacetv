class Empresa < ApplicationRecord
  belongs_to :ciudad
  belongs_to :entidad
  belongs_to :usuario

  before_save :uppercase

  validates :tipo, :nit, :razonsocial, :direccion, :telefono1, :ciudad, :entidad, :usuario, 
  presence: true #obligatorio

  def uppercase
    self.razonsocial.upcase!
    self.direccion.upcase!
    self.correo.downcase!
    self.regimen.upcase!
    self.contribuyente.upcase!
  end
end

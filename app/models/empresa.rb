class Empresa < ApplicationRecord
  belongs_to :ciudad
  belongs_to :entidad
  belongs_to :usuario

  before_save :uppercase

  validates :tipo, :nit, :razonsocial, :direccion, :telefono1, :ciudad, :entidad, :usuario, 
  presence: true #obligatorio

  validates :correo, format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i, on: :create }

  def uppercase
    self.razonsocial.upcase!
    self.direccion.upcase!
    self.correo.downcase!
    self.regimen.upcase!
    self.contribuyente.upcase!
  end
end

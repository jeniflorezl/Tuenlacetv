class Persona < ApplicationRecord
  belongs_to :tipo_documento
  belongs_to :barrio
  belongs_to :zona
  belongs_to :usuario
  has_many :entidades

  before_save :uppercase

  validates :tipo_documento, :documento, :nombre1, :apellido1, :barrio, :zona, 
  :tipopersona, :condicionfisica, :usuario, presence: true #obligatorio

  validates :documento, uniqueness: true

  validates :correo, format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i, on: :create }

  def uppercase
    self.nombre1.upcase!
    self.nombre2.upcase!
    self.apellido1.upcase!
    self.apellido2.upcase!
    self.direccion.upcase!
    self.correo.downcase!
    self.tipopersona.upcase!
    self.condicionfisica.upcase!
  end
end

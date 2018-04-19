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

  def uppercase
    self.nombre1.upcase!
    self.nombre2.upcase! unless self.nombre2.blank?
    self.apellido1.upcase!
    self.apellido2.upcase! unless self.apellido2.blank?
    self.direccion.upcase!
    self.correo.downcase! unless self.correo.blank?
    self.tipopersona.upcase!
    self.condicionfisica.upcase! unless self.condicionfisica.blank?
  end
end

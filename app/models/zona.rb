class Zona < ApplicationRecord
  belongs_to :ciudad
  belongs_to :usuario

  before_save :uppercase

  has_many :barrios
  has_many :direcciones_zonas
  has_many :tarifas
  has_many :personas
  has_many :senales

  validates :ciudad, :nombre, :usuario, presence: true #obligatorio

  def uppercase
    self.nombre.upcase!
  end
end

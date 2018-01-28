class Zona < ApplicationRecord
  belongs_to :ciudad
  has_many :barrios
  has_many :direcciones_zonas
  has_many :tarifas
  has_many :personas
  has_many :senales
  validates :ciudad_id, :nombre, :dirquejas, :usuario, presence: true #obligatorio
end

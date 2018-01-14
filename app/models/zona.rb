class Zona < ApplicationRecord
  belongs_to :ciudad
  has_many :barrios
  has_many :direcciones_zonas
  validates :ciudad_id, :nombre, :dirquejas, :usuario, presence: true #obligatorio
end

class Zona < ApplicationRecord
  belongs_to :ciudad
  has_many :barrios
  validates :ciudad_id, :nombre, :dirquejas, :usuario, presence: true #obligatorio
end

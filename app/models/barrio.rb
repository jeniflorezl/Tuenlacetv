class Barrio < ApplicationRecord
  belongs_to :zona
  has_many :personas
  has_many :senales
  validates :zona, :nombre, :usuario, presence: true #obligatorio
end

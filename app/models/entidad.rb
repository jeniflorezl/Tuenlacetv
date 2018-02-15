class Entidad < ApplicationRecord
  belongs_to :funcion
  belongs_to :persona
  has_many :senales
  validates :persona, :funcion, :usuario, presence: true #obligatorio
end

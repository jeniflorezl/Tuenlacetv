class Entidad < ApplicationRecord
  belongs_to :funcion
  belongs_to :persona
  belongs_to :usuario
  has_many :senales
  has_many :empresas
  has_many :ordenes

  validates :persona, :funcion, :usuario, presence: true #obligatorio
end

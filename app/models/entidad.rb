class Entidad < ApplicationRecord
  belongs_to :funcion
  belongs_to :persona
  belongs_to :usuario
  has_many :senales
  has_many :empresas

  validates :persona, :funcion, :usuario, presence: true #obligatorio
end

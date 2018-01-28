class Entidad < ApplicationRecord
  belongs_to :funcion
  belongs_to :persona
  has_many :senales
end

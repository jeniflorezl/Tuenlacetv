class Servicio < ApplicationRecord
    has_many :conceptos
    has_many :planes
    has_many :senales
    belongs_to :usuario
end

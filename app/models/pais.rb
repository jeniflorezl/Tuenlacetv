class Pais < ApplicationRecord
    has_many :ciudades
    validates :nombre, :usuario, presence: true #obligatorio
end

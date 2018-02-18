class Pais < ApplicationRecord
    has_many :ciudades

    before_save :uppercase

    validates :nombre, :usuario, presence: true #obligatorio

    def uppercase
        self.nombre.upcase!
    end
end

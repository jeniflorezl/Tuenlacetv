class TipoFacturacion < ApplicationRecord
    has_many :senales

    before_save :uppercase

    validates :nombre, :usuario, presence: true #obligatorio

    def uppercase
        self.nombre.upcase!
    end
end

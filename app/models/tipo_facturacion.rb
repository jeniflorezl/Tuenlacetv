class TipoFacturacion < ApplicationRecord
    has_many :senales
    belongs_to :usuario

    before_save :uppercase

    validates :nombre, :usuario, presence: true #obligatorio

    def uppercase
        self.nombre.upcase!
    end
end

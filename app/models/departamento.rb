class Departamento < ApplicationRecord
    belongs_to :pais
    belongs_to :usuario
    has_many :ciudades

    before_save :uppercase

    validates :pais, :nombre, :usuario, presence: true #obligatorio

    def uppercase
        self.nombre.upcase!
    end
end

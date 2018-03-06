class Departamento < ApplicationRecord
  belongs_to :pais
  has_many :ciudades
end

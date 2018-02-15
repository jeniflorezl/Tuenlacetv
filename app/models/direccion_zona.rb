class DireccionZona < ApplicationRecord
  belongs_to :zona
  validates :zona, :direccion, :usuario, presence: true #obligatorio
end

class DireccionZona < ApplicationRecord
  belongs_to :zona
  validates :zona_id, :direccion, :usuario, presence: true #obligatorio
end

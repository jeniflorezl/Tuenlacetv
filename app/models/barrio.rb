class Barrio < ApplicationRecord
  belongs_to :zona
  validates :zona_id, :nombre, :usuario, presence: true #obligatorio
end

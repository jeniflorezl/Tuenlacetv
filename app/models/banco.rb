class Banco < ApplicationRecord
  belongs_to :ciudad
  validates :nombre, :ciudad, :usuario, presence: true #obligatorio
end

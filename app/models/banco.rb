class Banco < ApplicationRecord
  belongs_to :ciudad
  validates :nombre, :usuario, presence: true #obligatorio
end

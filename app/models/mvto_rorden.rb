class MvtoRorden < ApplicationRecord
  belongs_to :registro_orden
  belongs_to :usuario

  validates :registro_orden, :valor, :usuario, presence: true #obligatorio
end

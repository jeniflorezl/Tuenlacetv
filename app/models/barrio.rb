class Barrio < ApplicationRecord
  belongs_to :zona
  belongs_to :usuario
  has_many :personas
  has_many :senales

  before_save :uppercase

  validates :zona, :nombre, :usuario, presence: true #obligatorio

  def uppercase
    self.nombre.upcase!
  end
end

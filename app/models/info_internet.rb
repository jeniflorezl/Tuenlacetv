class InfoInternet < ApplicationRecord
  belongs_to :usuario
  belongs_to :senal

  before_save :uppercase

  validates :senal, :direccionip, :velocidad, :mac1, :usuario, presence: true #obligatorio

  def uppercase
    self.serialm.upcase!
    self.marcam.upcase!
  end
end

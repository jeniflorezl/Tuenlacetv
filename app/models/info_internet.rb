class InfoInternet < ApplicationRecord
  belongs_to :entidad
  belongs_to :usuario
  
  before_save :uppercase

  validates :entidad, :direccionip, :velocidad, :mac1, :usuario, presence: true #obligatorio

  def uppercase
    self.serialm.upcase!
    self.marcam.upcase!
  end
end

class Traslado < ApplicationRecord
  belongs_to :usuario

  before_save :uppercase

  validates :zonaAnt_id, :barrioAnt_id, :direccionAnt, :zonaNue_id, :barrioNue_id, 
  :direccionNue, :usuario, presence: true #obligatorio

  def uppercase
    self.direccionNue.upcase!
  end
end

class Traslado < ApplicationRecord
  belongs_to :usuario

  validates :zonaAnt_id, :barrioAnt_id, :direccionAnt, :zonaNue_id, :barrioNue_id, 
  :direccionNue, :usuario, presence: true #obligatorio
end

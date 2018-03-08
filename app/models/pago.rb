class Pago < ApplicationRecord
  belongs_to :entidad
  belongs_to :documento
  belongs_to :estado
  belongs_to :forma_pago
  belongs_to :banco
  belongs_to :entidad
  belongs_to :usuario

end

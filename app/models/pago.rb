class Pago < ApplicationRecord
  self.primary_keys = :documento_id, :nropago
  belongs_to :entidad
  belongs_to :documento
  belongs_to :estado
  belongs_to :forma_pago
  belongs_to :banco
  belongs_to :entidad
  belongs_to :usuario
  has_many :abonos, :class_name => 'Abono', :foreign_key => [:documento_id, :nropago]

end

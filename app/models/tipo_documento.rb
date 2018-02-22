class TipoDocumento < ApplicationRecord
    belongs_to :usuario
    has_many :personas
end

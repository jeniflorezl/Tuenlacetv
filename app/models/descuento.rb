class Descuento < ApplicationRecord
    belongs_to :usuario

    validates :usuario, presence: true #obligatorio
end

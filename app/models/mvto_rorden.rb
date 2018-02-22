class MvtoRorden < ApplicationRecord
  belongs_to :orden
  belongs_to :registro_orden
end

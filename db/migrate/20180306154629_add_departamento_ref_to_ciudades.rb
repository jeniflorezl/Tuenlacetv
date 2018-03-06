class AddDepartamentoRefToCiudades < ActiveRecord::Migration[5.1]
  def change
    add_reference :ciudades, :departamento, foreign_key: true
  end
end

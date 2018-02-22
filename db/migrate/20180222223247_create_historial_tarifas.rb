class CreateHistorialTarifas < ActiveRecord::Migration[5.1]
  def up
    create_table :historial_tarifas do |t|
      t.references :tarifa, foreign_key: true, null:false
      t.datetime :fechainicio, null:false
      t.datetime :fechavence, null:false
      t.string :ccosto, limit:4
      t.datetime :fechacre, null:false
      t.datetime :fechacam, null:false
      t.references :usuario, foreign_key: true, null:false
    end
    execute <<-SQL
    ALTER TABLE historial_tarifas 
      ADD  DEFAULT (getdate()) FOR fechacre
    ALTER TABLE historial_tarifas 
      ADD  DEFAULT (getdate()) FOR fechacam
    SQL
  end

  def down
    drop_table :historial_tarifas
  end
end

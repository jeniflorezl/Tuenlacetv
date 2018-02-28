class CreatePlantillaFact < ActiveRecord::Migration[5.1]
  def up
    create_table :plantilla_fact do |t|
      t.references :senal, foreign_key: true
      t.references :concepto, foreign_key: true
      t.references :estado, foreign_key: true, null:false
      t.references :tarifa, foreign_key: true
      t.datetime :fechaini, null:false
      t.datetime :fechafin, null:false
      t.datetime :fechacre, null:false
      t.datetime :fechacam, null:false
      t.references :usuario, foreign_key: true, null:false
    end
    execute <<-SQL
    ALTER TABLE plantilla_fact 
      ADD  DEFAULT (getdate()) FOR fechacre
    ALTER TABLE plantilla_fact 
      ADD  DEFAULT (getdate()) FOR fechacam
    SQL
  end

  def down
    drop_table :plantilla_fact
  end
end

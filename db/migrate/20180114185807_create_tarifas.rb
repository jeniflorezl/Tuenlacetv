class CreateTarifas < ActiveRecord::Migration[5.1]
  def up
    create_table :tarifas do |t|
      t.references :zona, foreign_key: true
      t.references :concepto, foreign_key: true
      t.references :plan, foreign_key: true
      t.money :valor, null:false
      t.char :estado, limit: 1
      t.datetime :fechacre
      t.datetime :fechacam
      t.varchar :usuario, limit: 15, null:false
    end
    execute <<-SQL
    ALTER TABLE tarifas
      ADD CONSTRAINT DF_tarifas_fechacre  
      DEFAULT (getdate()) FOR fechacre
    ALTER TABLE tarifas
      ADD CONSTRAINT DF_tarifas_fechacam  
      DEFAULT (getdate()) FOR fechacam
    SQL
  end

  def down
    execute <<-SQL
    ALTER TABLE tarifas
      DROP CONSTRAINT DF_tarifas_fechacre
    ALTER TABLE tarifas
      DROP CONSTRAINT DF_tarifas_fechacam
    SQL
    drop_table :tarifas
  end
end

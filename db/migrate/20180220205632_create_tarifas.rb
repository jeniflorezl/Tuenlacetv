class CreateTarifas < ActiveRecord::Migration[5.1]
  def up
    create_table :tarifas do |t|
      t.references :zona, foreign_key: true, null:false
      t.references :concepto, foreign_key: true, null:false
      t.references :plan, foreign_key: true, null:false
      t.money :valor, null:false
      t.references :estado, foreign_key: true, null:false
      t.datetime :fechacre, null:false
      t.datetime :fechacam, null:false
      t.references :usuario, foreign_key: true, null:false
    end
    execute <<-SQL
    ALTER TABLE tarifas 
      ADD  DEFAULT (getdate()) FOR fechacre
    ALTER TABLE tarifas 
      ADD  DEFAULT (getdate()) FOR fechacam
    SQL
  end

  def down
    drop_table :tarifas
  end
end

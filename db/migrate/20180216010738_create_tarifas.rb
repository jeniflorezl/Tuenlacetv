class CreateTarifas < ActiveRecord::Migration[5.1]
  def up
    create_table :tarifas do |t|
      t.references :zona, foreign_key: true
      t.references :concepto, foreign_key: true
      t.references :plan, foreign_key: true
      t.money :valor, null:false
      t.references :estado, foreign_key: true
      t.datetime :fechacre
      t.datetime :fechacam
      t.varchar :usuario, limit: 15, null:false
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

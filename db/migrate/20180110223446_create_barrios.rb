class CreateBarrios < ActiveRecord::Migration[5.1]
  def up
    create_table :barrios do |t|
      t.references :zona, foreign_key: true
      t.varchar :nombre, limit: 50, null:false
      t.datetime :fechacre
      t.datetime :fechacam
      t.varchar :usuario, limit: 15, null:false
    end
    execute <<-SQL
    ALTER TABLE barrios
      ADD CONSTRAINT DF_barrios_fechacre  
      DEFAULT (getdate()) FOR fechacre
    ALTER TABLE barrios
      ADD CONSTRAINT DF_barrios_fechacam  
      DEFAULT (getdate()) FOR fechacam
    SQL
  end

  def down
    execute <<-SQL
    ALTER TABLE barrios
      DROP CONSTRAINT DF_barrios_fechacre
    ALTER TABLE barrios
      DROP CONSTRAINT DF_barrios_fechacam
    SQL
    drop_table :barrios
  end
end

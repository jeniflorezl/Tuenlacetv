class CreateMvtoRorden < ActiveRecord::Migration[5.1]
  def up
    create_table :mvto_rorden do |t|
      t.references :registro_orden, foreign_key: true, null:false
      t.integer :orden_id, null:false
      t.references :concepto, foreign_key: true, null:false
      t.integer :nrorden, null:false
      t.string :valor, limit: 250, null:false
      t.datetime :fechacre, null:false
      t.datetime :fechacam, null:false
      t.references :usuario, foreign_key: true, null:false
    end
    execute <<-SQL
    ALTER TABLE mvto_rorden 
      ADD  DEFAULT (getdate()) FOR fechacre
    ALTER TABLE mvto_rorden 
      ADD  DEFAULT (getdate()) FOR fechacam
    ALTER TABLE mvto_rorden
      ADD CONSTRAINT FK_mvtororden_ordenes
      FOREIGN KEY (concepto_id,nrorden) REFERENCES ordenes(concepto_id,nrorden);
    SQL
  end

  def down
    drop_table :mvto_rorden
  end
end

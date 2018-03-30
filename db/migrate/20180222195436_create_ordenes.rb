class CreateOrdenes < ActiveRecord::Migration[5.1]
  def up
    create_table :ordenes, {:id => false} do |t|
      t.integer :id, null:false
      t.references :entidad, foreign_key: true, null:false
      t.references :concepto, foreign_key: true, null:false
      t.datetime :fechatrn, null:false
      t.datetime :fechaven, null:false
      t.integer :nrorden, null:false
      t.references :estado, foreign_key: true, null:false
      t.string :observacion, limit: 300
      t.references :tecnico, foreign_key: { to_table: :entidades }, null:false
      t.datetime :fechacre, null:false
      t.datetime :fechacam, null:false
      t.references :usuario, foreign_key: true, null:false
    end
    execute <<-SQL
    ALTER TABLE ordenes 
      ADD  DEFAULT (getdate()) FOR fechacre
    ALTER TABLE ordenes 
      ADD  DEFAULT (getdate()) FOR fechacam
    ALTER TABLE ordenes ADD PRIMARY KEY (concepto_id, nrorden);
    SQL
  end

  def down
    drop_table :ordenes
  end
end

class CreatePagos < ActiveRecord::Migration[5.1]
  def up
    create_table :pagos, {:id => false} do |t|
      t.integer :id, null:false
      t.references :entidad, foreign_key: true, null:false
      t.references :documento, foreign_key: true, null:false
      t.integer :nropago, null:false
      t.datetime :fechatrn, null:false
      t.datetime :fechaven, null:false
      t.money :valor, null:false
      t.references :estado, foreign_key: true, null:false
      t.string :observacion, limit: 300
      t.references :forma_pago, foreign_key: true, null:false
      t.references :banco, foreign_key: true, null:false
      t.references :cobrador, foreign_key: { to_table: :entidades }, null:false
      t.datetime :fechacre, null:false
      t.datetime :fechacam, null:false
      t.references :usuario, foreign_key: true, null:false
    end
    execute <<-SQL
    ALTER TABLE pagos 
      ADD  DEFAULT (getdate()) FOR fechacre
    ALTER TABLE pagos 
      ADD  DEFAULT (getdate()) FOR fechacam
    ALTER TABLE pagos ADD PRIMARY KEY (documento_id, nropago);
    SQL
  end
  
  def down
    drop_table :pagos
  end
end

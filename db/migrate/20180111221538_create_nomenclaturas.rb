class CreateNomenclaturas < ActiveRecord::Migration[5.1]
  def up
    create_table :nomenclaturas do |t|
      t.varchar :abreviatura, limit: 10, null:false
      t.varchar :descripcion, limit: 50
      t.integer :orden
      t.datetime :fechacre
      t.datetime :fechacam
      t.varchar :usuario, limit: 15, null:false
    end
    execute <<-SQL
    ALTER TABLE nomenclaturas 
      ADD  DEFAULT (getdate()) FOR fechacre
    ALTER TABLE nomenclaturas 
      ADD  DEFAULT (getdate()) FOR fechacam
    SQL
  end

  def down
    drop_table :nomenclaturas
  end
end

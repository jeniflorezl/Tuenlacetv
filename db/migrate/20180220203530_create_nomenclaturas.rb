class CreateNomenclaturas < ActiveRecord::Migration[5.1]
  def up
    create_table :nomenclaturas do |t|
      t.char :abreviatura, limit: 6, null:false
      t.string :descripcion, limit: 50
      t.integer :orden
      t.datetime :fechacre, null:false
      t.datetime :fechacam, null:false
      t.references :usuario, foreign_key: true, null:false
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

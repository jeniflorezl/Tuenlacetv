class CreateNotas < ActiveRecord::Migration[5.1]
  def up
    create_table :notas do |t|
      t.references :entidad, foreign_key: true, null:false
      t.string :nota, limit: 300
      t.datetime :fecha, null:false
      t.datetime :fechacre, null:false
      t.datetime :fechacam, null:false
      t.references :usuario, foreign_key: true, null:false
    end
    execute <<-SQL
    ALTER TABLE notas 
      ADD  DEFAULT (getdate()) FOR fechacre
    ALTER TABLE notas 
      ADD  DEFAULT (getdate()) FOR fechacam
    SQL
  end

  def down
    drop_table :notas
  end
end

class CreateGrupos < ActiveRecord::Migration[5.1]
  def up
    create_table :grupos do |t|
      t.string :descripcion, limit: 80
      t.datetime :fechacre, null:false
      t.datetime :fechacam, null:false
      t.references :usuario, foreign_key: true, null:false
    end
    execute <<-SQL
    ALTER TABLE grupos 
      ADD  DEFAULT (getdate()) FOR fechacre
    ALTER TABLE grupos 
      ADD  DEFAULT (getdate()) FOR fechacam
    SQL
  end

  def down
    drop_table :grupos
  end
end

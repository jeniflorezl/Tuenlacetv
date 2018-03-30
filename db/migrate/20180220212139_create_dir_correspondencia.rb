class CreateDirCorrespondencia < ActiveRecord::Migration[5.1]
  def up
    create_table :dir_correspondencia do |t|
      t.references :entidad, foreign_key: true, null:false
      t.string :direccion, limit: 100, null:false
      t.datetime :fechacre, null:false
      t.datetime :fechacam, null:false
      t.references :usuario, foreign_key: true, null:false
    end
    execute <<-SQL
    ALTER TABLE dir_correspondencia 
      ADD  DEFAULT (getdate()) FOR fechacre
    ALTER TABLE dir_correspondencia 
      ADD  DEFAULT (getdate()) FOR fechacam
    SQL
  end

  def down
    drop_table :dir_correspondencia
  end
end

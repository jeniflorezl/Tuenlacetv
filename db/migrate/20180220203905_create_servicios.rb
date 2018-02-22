class CreateServicios < ActiveRecord::Migration[5.1]
  def up
    create_table :servicios do |t|
      t.varchar :nombre, limit: 20, null:false
      t.datetime :fechacre, null:false
      t.datetime :fechacam, null:false
      t.references :usuario, foreign_key: true, null:false
    end
    execute <<-SQL
    ALTER TABLE servicios 
      ADD  DEFAULT (getdate()) FOR fechacre
    ALTER TABLE servicios 
      ADD  DEFAULT (getdate()) FOR fechacam
    SQL
  end

  def down
    drop_table :servicios
  end
end

class CreateServicios < ActiveRecord::Migration[5.1]
  def up
    create_table :servicios do |t|
      t.varchar :nombre, limit: 20, null:false
      t.datetime :fechacre
      t.datetime :fechacam
      t.varchar :usuario, limit: 15, null:false
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

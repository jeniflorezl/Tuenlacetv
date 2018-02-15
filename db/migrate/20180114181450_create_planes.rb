class CreatePlanes < ActiveRecord::Migration[5.1]
  def up
    create_table :planes do |t|
      t.references :servicio, foreign_key: true
      t.varchar :nombre, limit: 20, null:false
      t.datetime :fechacre
      t.datetime :fechacam
      t.varchar :usuario, limit: 15, null:false
    end
    execute <<-SQL
    ALTER TABLE planes 
      ADD  DEFAULT (getdate()) FOR fechacre
    ALTER TABLE planes 
      ADD  DEFAULT (getdate()) FOR fechacam
    SQL
  end

  def down
    drop_table :planes
  end
end

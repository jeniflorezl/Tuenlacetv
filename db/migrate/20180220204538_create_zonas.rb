class CreateZonas < ActiveRecord::Migration[5.1]
  def up
    create_table :zonas do |t|
      t.references :ciudad, foreign_key: true, null:false
      t.varchar :nombre, limit: 50, null:false
      t.datetime :fechacre, null:false
      t.datetime :fechacam, null:false
      t.references :usuario, foreign_key: true, null:false
    end
    execute <<-SQL
    ALTER TABLE zonas 
      ADD  DEFAULT (getdate()) FOR fechacre
    ALTER TABLE zonas 
      ADD  DEFAULT (getdate()) FOR fechacam
    SQL
  end

  def down
    drop_table :zonas
  end
end

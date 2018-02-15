class CreateTipoInstalaciones < ActiveRecord::Migration[5.1]
  def up
    create_table :tipo_instalaciones do |t|
      t.varchar :nombre, limit: 20, null:false
      t.datetime :fechacre
      t.datetime :fechacam
      t.varchar :usuario, limit: 15, null:false
    end
    execute <<-SQL
    ALTER TABLE tipo_instalaciones 
      ADD  DEFAULT (getdate()) FOR fechacre
    ALTER TABLE tipo_instalaciones 
      ADD  DEFAULT (getdate()) FOR fechacam
    SQL
  end

  def down
    drop_table :tipo_instalaciones
  end
end

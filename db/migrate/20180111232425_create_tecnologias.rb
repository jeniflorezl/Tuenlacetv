class CreateTecnologias < ActiveRecord::Migration[5.1]
  def up
    create_table :tecnologias do |t|
      t.varchar :nombre, limit: 20, null:false
      t.datetime :fechacre
      t.datetime :fechacam
      t.varchar :usuario, limit: 15, null:false
    end
    execute <<-SQL
    ALTER TABLE tecnologias 
      ADD  DEFAULT (getdate()) FOR fechacre
    ALTER TABLE tecnologias 
      ADD  DEFAULT (getdate()) FOR fechacam
    SQL
  end

  def down
    drop_table :tecnologias
  end
end

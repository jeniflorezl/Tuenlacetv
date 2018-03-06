class CreateDepartamentos < ActiveRecord::Migration[5.1]
  def up
    create_table :departamentos do |t|
      t.references :pais, foreign_key: true
      t.varchar :nombre, limit: 80, null:false
      t.char :codigo, limit: 5
      t.datetime :fechacre, null:false
      t.datetime :fechacam, null:false
      t.references :usuario, foreign_key: true, null:false
    end
    execute <<-SQL
    ALTER TABLE departamentos 
      ADD  DEFAULT (getdate()) FOR fechacre
    ALTER TABLE departamentos 
      ADD  DEFAULT (getdate()) FOR fechacam
    SQL
  end

  def down
    drop_table :departamentos
  end
end

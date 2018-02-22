class CreateEstados < ActiveRecord::Migration[5.1]
  def up
    create_table :estados do |t|
      t.varchar :nombre, limit: 20, null:false
      t.char :abreviatura, limit: 1, null:false
      t.datetime :fechacre, null:false
      t.datetime :fechacam, null:false
      t.varchar :usuario, limit: 15, null:false
    end
    execute <<-SQL
    ALTER TABLE estados 
      ADD  DEFAULT (getdate()) FOR fechacre
    ALTER TABLE estados 
      ADD  DEFAULT (getdate()) FOR fechacam
    SQL
  end

  def down
    drop_table :estados
  end
end

class CreateUsuarios < ActiveRecord::Migration[5.1]
  def up
    create_table :usuarios do |t|
      t.varchar :login, limit: 10, null:false
      t.varchar :nombre, limit: 50, null:false
      t.string :password_digest
      t.char :nivel, limit: 1
      t.string :token
      t.datetime :fechacre
      t.datetime :fechacam
      t.varchar :usuario, limit: 15, null:false
    end
    execute <<-SQL
    ALTER TABLE usuarios 
      ADD  DEFAULT (getdate()) FOR fechacre
    ALTER TABLE usuarios 
      ADD  DEFAULT (getdate()) FOR fechacam
    SQL
  end

  def down
    drop_table :usuarios
  end
end

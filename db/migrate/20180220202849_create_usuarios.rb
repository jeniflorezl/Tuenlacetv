class CreateUsuarios < ActiveRecord::Migration[5.1]
  def up
    create_table :usuarios do |t|
      t.string :login, limit: 10, null:false
      t.varchar :nombre, limit: 50, null:false
      t.string :password_digest
      t.string :token
      t.char :nivel, limit: 1
      t.references :estado, foreign_key: true
      t.char :tipoImpresora, limit: 1
      t.datetime :fechacre, null:false
      t.datetime :fechacam, null:false
      t.varchar :usuariocre, null:false
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

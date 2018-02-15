class CreateEntidades < ActiveRecord::Migration[5.1]
  def up
    create_table :entidades do |t|
      t.references :funcion, foreign_key: true
      t.references :persona, foreign_key: true
      t.datetime :fechacre
      t.datetime :fechacam
      t.varchar :usuario, limit: 15, null:false
    end
    execute <<-SQL
    ALTER TABLE entidades 
      ADD  DEFAULT (getdate()) FOR fechacre
    ALTER TABLE entidades 
      ADD  DEFAULT (getdate()) FOR fechacam
    SQL
  end

  def down
    drop_table :entidades
  end
end

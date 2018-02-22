class CreateEntidades < ActiveRecord::Migration[5.1]
  def up
    create_table :entidades do |t|
      t.references :funcion, foreign_key: true, null:false
      t.references :persona, foreign_key: true, null:false
      t.datetime :fechacre, null:false
      t.datetime :fechacam, null:false
      t.references :usuario, foreign_key: true, null:false
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

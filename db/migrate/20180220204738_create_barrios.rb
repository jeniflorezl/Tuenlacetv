class CreateBarrios < ActiveRecord::Migration[5.1]
  def up
    create_table :barrios do |t|
      t.references :zona, foreign_key: true, null:false
      t.varchar :nombre, limit: 50, null:false
      t.datetime :fechacre, null:false
      t.datetime :fechacam, null:false
      t.references :usuario, foreign_key: true, null:false
    end
    execute <<-SQL
    ALTER TABLE barrios 
      ADD  DEFAULT (getdate()) FOR fechacre
    ALTER TABLE barrios 
      ADD  DEFAULT (getdate()) FOR fechacam
    SQL
  end

  def down
    drop_table :barrios
  end
end

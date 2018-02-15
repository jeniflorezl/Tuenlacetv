class CreateBarrios < ActiveRecord::Migration[5.1]
  def up
    create_table :barrios do |t|
      t.references :zona, foreign_key: true
      t.varchar :nombre, limit: 50, null:false
      t.datetime :fechacre
      t.datetime :fechacam
      t.varchar :usuario, limit: 15, null:false
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

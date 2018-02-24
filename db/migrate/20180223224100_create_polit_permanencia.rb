class CreatePolitPermanencia < ActiveRecord::Migration[5.1]
  def up
    create_table :polit_permanencia do |t|
      t.integer :permanencia, null:false
      t.char :medida, limit:1, null:false
      t.string :cantidad1, limit:5
      t.string :cantidad2, limit:5
      t.string :cantidad3, limit:5
      t.datetime :fechacre, null:false
      t.datetime :fechacam, null:false
      t.references :usuario, foreign_key: true, null:false
    end
    execute <<-SQL
    ALTER TABLE polit_permanencia 
      ADD  DEFAULT (getdate()) FOR fechacre
    ALTER TABLE polit_permanencia 
      ADD  DEFAULT (getdate()) FOR fechacam
    SQL
  end

  def down
    drop_table :polit_permanencia
  end
end

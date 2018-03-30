class CreatePermanencias < ActiveRecord::Migration[5.1]
  def up
    create_table :permanencias do |t|
      t.references :entidad, foreign_key: true, null:false
      t.datetime :fechaDcto, null:false
      t.datetime :fechacre, null:false
      t.datetime :fechacam, null:false
      t.references :usuario, foreign_key: true, null:false
    end
    execute <<-SQL
    ALTER TABLE permanencias 
      ADD  DEFAULT (getdate()) FOR fechacre
    ALTER TABLE permanencias 
      ADD  DEFAULT (getdate()) FOR fechacam
    SQL
  end

  def down
    drop_table :permanencias
  end
end

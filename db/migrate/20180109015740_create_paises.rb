class CreatePaises < ActiveRecord::Migration[5.1]
  def up
    create_table :paises do |t|
      t.varchar :nombre, limit: 50, null:false
      t.datetime :fechacre
      t.datetime :fechacam
      t.varchar :usuario, limit: 15, null:false
    end
    execute <<-SQL
    ALTER TABLE paises
      ADD CONSTRAINT DF_paises_fechacre  
      DEFAULT (getdate()) FOR fechacre
    ALTER TABLE paises
      ADD CONSTRAINT DF_paises_fechacam  
      DEFAULT (getdate()) FOR fechacam
    SQL
  end

  def down
    execute <<-SQL
    ALTER TABLE paises
      DROP CONSTRAINT DF_paises_fechacre
    ALTER TABLE cities
      DROP CONSTRAINT DF_paises_fechacam
    SQL
    drop_table :paises
  end

end

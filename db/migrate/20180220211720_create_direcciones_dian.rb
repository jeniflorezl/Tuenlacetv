class CreateDireccionesDian < ActiveRecord::Migration[5.1]
  def up
    create_table :direcciones_dian do |t|
      t.references :entidad, foreign_key: true, null:false
      t.references :nomenclatura, foreign_key: true, null:false
      t.integer :nrox
      t.string :letrax, limit: 3 
      t.integer :nroy
      t.string :letray, limit: 3 
      t.integer :nroz
      t.string :complemento, limit: 50
      t.datetime :fechacre, null:false
      t.datetime :fechacam, null:false
      t.references :usuario, foreign_key: true, null:false
    end
    execute <<-SQL
    ALTER TABLE direcciones_dian 
      ADD  DEFAULT (getdate()) FOR fechacre
    ALTER TABLE direcciones_dian 
      ADD  DEFAULT (getdate()) FOR fechacam
    SQL
  end

  def down
    drop_table :direcciones_dian
  end
end

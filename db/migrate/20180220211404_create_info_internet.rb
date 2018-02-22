class CreateInfoInternet < ActiveRecord::Migration[5.1]
  def up
    create_table :info_internet do |t|
      t.references :senal, foreign_key: true, null:false
      t.string :direccionip, limit: 20
      t.integer :velocidad
      t.string :mac1, limit: 20
      t.string :mac2, limit: 20
      t.string :serialm, limit: 50
      t.string :marcam, limit: 50
      t.string :mascarasub, limit: 20
      t.string :dns, limit: 20
      t.string :gateway, limit: 20
      t.integer :nodo
      t.string :clavewifi, limit: 50
      t.varchar :equipo, limit: 2
      t.datetime :fechacre, null:false
      t.datetime :fechacam, null:false
      t.references :usuario, foreign_key: true, null:false
    end
    execute <<-SQL
    ALTER TABLE info_internet 
      ADD  DEFAULT (getdate()) FOR fechacre
    ALTER TABLE info_internet 
      ADD  DEFAULT (getdate()) FOR fechacam
    SQL
  end

  def down
    drop_table :info_internet
  end
end

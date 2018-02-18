class CreateInfoInternet < ActiveRecord::Migration[5.1]
  def change
    create_table :info_internet do |t|
      t.references :senal, foreign_key: true
      t.varchar :direccionip, limit: 50
      t.integer :velocidad
      t.varchar :mac1, limit: 50
      t.varchar :mac2, limit: 50
      t.varchar :serialm, limit: 50
      t.varchar :marcam, limit: 50
      t.varchar :mascarasub, limit: 50
      t.varchar :dns, limit: 20
      t.varchar :gateway, limit: 20
      t.integer :nodo, limit: 50
      t.varchar :clavewifi, limit: 50
      t.varchar :modem, limit: 50
      t.timestamps
    end
  end
end

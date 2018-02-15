class CreateSenales < ActiveRecord::Migration[5.1]
  def up
    create_table :senales do |t|
      t.references :entidad, foreign_key: true
      t.references :servicio, foreign_key: true
      t.varchar :contrato, limit: 20, null:false
      t.varchar :direccion, limit: 200
      t.varchar :urbanizacion, limit: 200
      t.varchar :torre, limit: 20
      t.varchar :apto, limit: 20
      t.varchar :telefono1, limit: 20
      t.varchar :telefono2, limit: 20
      t.varchar :contacto, limit: 20
      t.integer :estrato
      t.varchar :vivienda, limit: 15
      t.varchar :observacion, limit: 200
      t.references :barrio, foreign_key: true
      t.references :zona, foreign_key: true
      t.references :estado, foreign_key: true
      t.datetime :fechacontrato, null:false
      t.integer :televisores      
      t.varchar :precinto, limit: 10
      t.references :vendedor, foreign_key: { to_table: :entidades }
      t.references :tipo_instalacion, foreign_key: true
      t.references :tecnologia, foreign_key: true
      t.varchar :tiposervicio, limit: 20
      t.varchar :areainstalacion, limit: 20
      t.datetime :fechacre
      t.datetime :fechacam
      t.varchar :usuario, limit: 15, null:false
    end
    execute <<-SQL
    ALTER TABLE senales 
      ADD  DEFAULT (getdate()) FOR fechacre
    ALTER TABLE senales 
      ADD  DEFAULT (getdate()) FOR fechacam
    SQL
  end

  def down
    drop_table :senales
  end
end

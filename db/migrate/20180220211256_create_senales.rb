class CreateSenales < ActiveRecord::Migration[5.1]
  def up
    create_table :senales do |t|
      t.references :entidad, foreign_key: true, null:false
      t.string :contrato, limit: 20, null:false
      t.string :direccion, limit: 200, null:false
      t.string :urbanizacion, limit: 200
      t.string :torre, limit: 20
      t.string :apto, limit: 20
      t.references :barrio, foreign_key: true, null:false
      t.references :zona, foreign_key: true, null:false
      t.string :telefono1, limit: 20
      t.string :telefono2, limit: 20
      t.string :contacto, limit: 20
      t.integer :estrato
      t.char :vivienda, limit: 1
      t.string :observacion, limit: 200
      t.datetime :fechacontrato, null:false
      t.integer :permanencia
      t.integer :televisores 
      t.integer :decos
      t.string :precinto, limit: 10
      t.references :vendedor, foreign_key: { to_table: :entidades }, null:false
      t.references :tipo_instalacion, foreign_key: true, null:false
      t.references :tecnologia, foreign_key: true, null:false
      t.char :tiposervicio, limit: 1
      t.char :areainstalacion, limit: 1
      t.datetime :fechacre, null:false
      t.datetime :fechacam, null:false
      t.references :usuario, foreign_key: true, null:false
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

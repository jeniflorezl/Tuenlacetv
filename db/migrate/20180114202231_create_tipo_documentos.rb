class CreateTipoDocumentos < ActiveRecord::Migration[5.1]
  def up
    create_table :tipo_documentos do |t|
      t.varchar :nombre, limit: 20, null:false
      t.datetime :fechacre
      t.datetime :fechacam
      t.varchar :usuario, limit: 15, null:false
    end
    execute <<-SQL
    ALTER TABLE tipo_documentos
      ADD CONSTRAINT DF_tipo_documentos_fechacre  
      DEFAULT (getdate()) FOR fechacre
    ALTER TABLE tipo_documentos
      ADD CONSTRAINT DF_tipo_documentos_fechacam  
      DEFAULT (getdate()) FOR fechacam
    SQL
  end

  def down
    execute <<-SQL
    ALTER TABLE tipo_documentos
      DROP CONSTRAINT DF_tipo_documentos_fechacre
    ALTER TABLE tipo_documentos
      DROP CONSTRAINT DF_tipo_documentos_fechacam
    SQL
    drop_table :tipo_documentos
  end
end

class CreateDocumentos < ActiveRecord::Migration[5.1]
  def up
    create_table :documentos do |t|
      t.varchar :nombre, limit: 20, null:false
      t.char :abreviatura, limit: 3, null:false
      t.datetime :fechacre, null:false
      t.datetime :fechacam, null:false
      t.references :usuario, foreign_key: true, null:false
    end
    execute <<-SQL
    ALTER TABLE documentos 
      ADD  DEFAULT (getdate()) FOR fechacre
    ALTER TABLE documentos 
      ADD  DEFAULT (getdate()) FOR fechacam
    SQL
  end

  def down
    drop_table :documentos
  end
end

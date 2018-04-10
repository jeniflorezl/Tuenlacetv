class CreateDescuentos < ActiveRecord::Migration[5.1]
  def up
    create_table :descuentos do |t|
      t.integer :pago_id
      t.references :doc_pagos, foreign_key: { to_table: :documentos }
      t.integer :nropago
      t.integer :dcto_id
      t.references :doc_dctos, foreign_key: { to_table: :documentos }
      t.integer :nrodcto
      t.datetime :fechacre, null:false
      t.datetime :fechacam, null:false
      t.references :usuario, foreign_key: true, null:false
    end
    execute <<-SQL
    ALTER TABLE descuentos 
      ADD  DEFAULT (getdate()) FOR fechacre
    ALTER TABLE descuentos 
      ADD  DEFAULT (getdate()) FOR fechacam
    ALTER TABLE descuentos
      ADD CONSTRAINT FK_descuentos_pagos
      FOREIGN KEY (doc_pagos_id, nropago) REFERENCES pagos(documento_id,nropago);
    ALTER TABLE descuentos
      ADD CONSTRAINT FK_descuentos_dcto
      FOREIGN KEY (doc_dctos_id, nrodcto) REFERENCES pagos(documento_id,nropago);
    SQL
  end

  def down
    drop_table :descuentos
  end
end

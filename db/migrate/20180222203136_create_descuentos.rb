class CreateDescuentos < ActiveRecord::Migration[5.1]
  def up
    create_table :descuentos do |t|
      t.integer :pago_id, null:false
      t.references :documento, foreign_key: true, null:false
      t.decimal :nropago, null:false
      t.money :valor, null:false
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
      FOREIGN KEY (pago_id,documento_id,nropago) REFERENCES pagos(id,documento_id,nropago);
    SQL
  end

  def down
    drop_table :descuentos
  end
end

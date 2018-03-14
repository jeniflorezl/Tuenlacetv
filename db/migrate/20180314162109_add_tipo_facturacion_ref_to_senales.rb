class AddTipoFacturacionRefToSenales < ActiveRecord::Migration[5.1]
  def change
    add_reference :senales, :tipo_facturacion, foreign_key: true
  end
end

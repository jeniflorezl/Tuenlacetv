class AddTipoFacturacionRefToNotaFact < ActiveRecord::Migration[5.1]
  def change
    add_reference :notas_fact, :tipo_facturacion, foreign_key: true
  end
end

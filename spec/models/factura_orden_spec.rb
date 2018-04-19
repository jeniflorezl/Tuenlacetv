require 'rails_helper'

RSpec.describe FacturaOrden, :type => :model do
  it "is valid with a bill, order and user" do
    factura_orden = FacturaOrden.new(factura_id: 1, documento_id: 1, prefijo: "AE", 
        nrofact: 1, orden_id: 1, concepto_id: 1, nrorden: 1, usuario_id: 1)
    expect(factura_orden).to be_valid
  end

  it "is invalid without an user" do
    factura_orden = FacturaOrden.new(usuario_id: nil)
    factura_orden.valid?
    expect(factura_orden.errors[:usuario]).to include("can't be blank")
  end
end
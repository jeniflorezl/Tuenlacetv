require 'rails_helper'

RSpec.describe DetalleFactura, :type => :model do
  it "is valid with a bill, concept, amount, value, iva percentage, iva, observation,
  operation and user" do
    detalle_factura = DetalleFactura.new(factura_id: 1, documento_id: 1, prefijo: "AR", 
        nrofact: 1, concepto_id: 1, cantidad: 1, valor: 20000, porcentajeIva: 19, 
        iva: 3000, observacion: "Mensualidad", operacion: "+", usuario_id: 1)
    expect(detalle_factura).to be_valid
  end

  it "is invalid without a concept" do
    detalle_factura = DetalleFactura.new(concepto_id: nil)
    detalle_factura.valid?
    expect(detalle_factura.errors[:concepto]).to include("can't be blank")
  end

  it "is invalid without a value" do
    detalle_factura = DetalleFactura.new(valor: nil)
    detalle_factura.valid?
    expect(detalle_factura.errors[:valor]).to include("can't be blank")
  end

  it "is invalid without an iva percentage" do
    detalle_factura = DetalleFactura.new(porcentajeIva: nil)
    detalle_factura.valid?
    expect(detalle_factura.errors[:porcentajeIva]).to include("can't be blank")
  end

  it "is invalid without an iva" do
    detalle_factura = DetalleFactura.new(iva: nil)
    detalle_factura.valid?
    expect(detalle_factura.errors[:iva]).to include("can't be blank")
  end

  it "is invalid without an operation" do
    detalle_factura = DetalleFactura.new(operacion: nil)
    detalle_factura.valid?
    expect(detalle_factura.errors[:operacion]).to include("can't be blank")
  end

  it "is invalid without an user" do
    detalle_factura = DetalleFactura.new(usuario_id: nil)
    detalle_factura.valid?
    expect(detalle_factura.errors[:usuario]).to include("can't be blank")
  end
end
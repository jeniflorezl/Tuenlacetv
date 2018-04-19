require 'rails_helper'

RSpec.describe DetalleOrden, :type => :model do
  it "is valid with a order, article, amount, value, iva percentage, iva, cost, observation
  and user" do
    detalle_orden = DetalleOrden.new(orden_id: 1, concepto_id: 5, nrorden: 1, articulo_id: 1,
        cantidad: 1, valor: 21000, porcentajeIva: 19, iva: 2400, costo: 25400, 
        observacion: "punto adcional", usuario_id: 1)
    expect(detalle_orden).to be_valid
  end

  it "is invalid without a concept" do
    detalle_orden = DetalleOrden.new(concepto_id: nil)
    detalle_orden.valid?
    expect(detalle_orden.errors[:concepto]).to include("can't be blank")
  end

  it "is invalid without a value" do
    detalle_orden = DetalleOrden.new(valor: nil)
    detalle_orden.valid?
    expect(detalle_orden.errors[:valor]).to include("can't be blank")
  end

  it "is invalid without an iva percentage" do
    detalle_orden = DetalleOrden.new(porcentajeIva: nil)
    detalle_orden.valid?
    expect(detalle_orden.errors[:porcentajeIva]).to include("can't be blank")
  end

  it "is invalid without an iva" do
    detalle_orden = DetalleOrden.new(iva: nil)
    detalle_orden.valid?
    expect(detalle_orden.errors[:iva]).to include("can't be blank")
  end

  it "is invalid without a cost" do
    detalle_orden = DetalleOrden.new(costo: nil)
    detalle_orden.valid?
    expect(detalle_orden.errors[:costo]).to include("can't be blank")
  end

  it "is invalid without an user" do
    detalle_orden = DetalleOrden.new(usuario_id: nil)
    detalle_orden.valid?
    expect(detalle_orden.errors[:usuario]).to include("can't be blank")
  end
end
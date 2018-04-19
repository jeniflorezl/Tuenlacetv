require 'rails_helper'

RSpec.describe Facturacion, :type => :model do
  it "is valid with a entity, document, transaction date, expiration date, value
  iva, days, prefix, bill number, state identifier, observation, report and user" do
    factura = Facturacion.new(entidad_id: 1, documento_id: 1, fechatrn: "01/01/2018",
        fechaven: "30/01/2018", valor: 20000, iva: 2300, dias: 30, prefijo: "AR", 
        nrofact: 1, estado_id: 1, observacion: "Mensualidad", reporta: "1", usuario_id: 1)
    expect(factura).to be_valid
  end
  
  it "is invalid without an entity" do
    factura = Facturacion.new(entidad_id: nil)
    factura.valid?
    expect(factura.errors[:entidad]).to include("can't be blank")
  end

  it "is invalid without a document" do
    factura = Facturacion.new(documento_id: nil)
    factura.valid?
    expect(factura.errors[:documento]).to include("can't be blank")
  end

  it "is invalid without a transaction date" do
    factura = Facturacion.new(fechatrn: nil)
    factura.valid?
    expect(factura.errors[:fechatrn]).to include("can't be blank")
  end

  it "is invalid without an expiration date" do
    factura = Facturacion.new(fechaven: nil)
    factura.valid?
    expect(factura.errors[:fechaven]).to include("can't be blank")
  end

  it "is invalid without a value" do
    factura = Facturacion.new(valor: nil)
    factura.valid?
    expect(factura.errors[:valor]).to include("can't be blank")
  end

  it "is invalid without an iva" do
    factura = Facturacion.new(iva: nil)
    factura.valid?
    expect(factura.errors[:iva]).to include("can't be blank")
  end

  it "is invalid without a days" do
    factura = Facturacion.new(dias: nil)
    factura.valid?
    expect(factura.errors[:dias]).to include("can't be blank")
  end

  it "is invalid without a prefix" do
    factura = Facturacion.new(prefijo: nil)
    factura.valid?
    expect(factura.errors[:prefijo]).to include("can't be blank")
  end

  it "is invalid without a bill number" do
    factura = Facturacion.new(nrofact: nil)
    factura.valid?
    expect(factura.errors[:nrofact]).to include("can't be blank")
  end

  it "is invalid without a state identifier" do
    factura = Facturacion.new(estado_id: nil)
    factura.valid?
    expect(factura.errors[:estado]).to include("can't be blank")
  end

  it "is invalid without a report" do
    factura = Facturacion.new(reporta: nil)
    factura.valid?
    expect(factura.errors[:reporta]).to include("can't be blank")
  end

  it "is invalid without an user" do
    factura = Facturacion.new(usuario_id: nil)
    factura.valid?
    expect(factura.errors[:usuario]).to include("can't be blank")
  end
end
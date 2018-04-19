require 'rails_helper'

RSpec.describe Anticipo, :type => :model do
  it "is valid with a entity, service, bill, payment, transaction date, expiration date, 
  value and user" do
    anticipo = Anticipo.new(entidad_id: 1, servicio_id: 1, factura_id: 1, 
        doc_factura_id: 1, prefijo: "AR", nrofact: 1, pago_id: 1, doc_pagos_id: 1,
        nropago: 1, fechatrn: "01/01/2018", fechaven: "30/01/2018", valor: 20000, 
        usuario_id: 1)
    expect(anticipo).to be_valid
  end

  it "is invalid without an entity" do
    anticipo = Anticipo.new(entidad_id: nil)
    anticipo.valid?
    expect(anticipo.errors[:entidad]).to include("can't be blank")
  end

  it "is invalid without a service" do
    anticipo = Anticipo.new(servicio_id: nil)
    anticipo.valid?
    expect(anticipo.errors[:servicio]).to include("can't be blank")
  end

  it "is invalid without a transaction date" do
    anticipo = Anticipo.new(fechatrn: nil)
    anticipo.valid?
    expect(anticipo.errors[:fechatrn]).to include("can't be blank")
  end

  it "is invalid without an expiration date" do
    anticipo = Anticipo.new(fechaven: nil)
    anticipo.valid?
    expect(anticipo.errors[:fechaven]).to include("can't be blank")
  end

  it "is invalid without a value" do
    anticipo = Anticipo.new(valor: nil)
    anticipo.valid?
    expect(anticipo.errors[:valor]).to include("can't be blank")
  end

  it "is invalid without an user" do
    anticipo = Anticipo.new(usuario_id: nil)
    anticipo.valid?
    expect(anticipo.errors[:usuario]).to include("can't be blank")
  end
end
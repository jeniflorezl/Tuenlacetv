require 'rails_helper'

RSpec.describe Abono, :type => :model do
  it "is valid with a payment, bill, concept, payment date, balance, payment and user" do
    abono = Abono.new(pago_id: 1, doc_pagos_id: 3, nropago: 1, factura_id: 1, 
        doc_factura_id: 1, prefijo: "AR", nrofact: 1, concepto_id: 3,
        fechabono: "01/01/2018", saldo: 10000, abono: 10000, usuario_id: 1)
    expect(abono).to be_valid
  end
  
  it "is invalid without a concept" do
    abono = Abono.new(concepto_id: nil)
    abono.valid?
    expect(abono.errors[:concepto]).to include("can't be blank")
  end

  it "is invalid without a payment date" do
    abono = Abono.new(fechabono: nil)
    abono.valid?
    expect(abono.errors[:fechabono]).to include("can't be blank")
  end

  it "is invalid without a balance" do
    abono = Abono.new(saldo: nil)
    abono.valid?
    expect(abono.errors[:saldo]).to include("can't be blank")
  end

  it "is invalid without a payment" do
    abono = Abono.new(abono: nil)
    abono.valid?
    expect(abono.errors[:abono]).to include("can't be blank")
  end

  it "is invalid without an user" do
    abono = Abono.new(usuario_id: nil)
    abono.valid?
    expect(abono.errors[:usuario]).to include("can't be blank")
  end
end
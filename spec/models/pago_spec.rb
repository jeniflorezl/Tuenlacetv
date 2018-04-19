require 'rails_helper'

RSpec.describe Pago, :type => :model do
  it "is valid with a entity, document, payment number, transaction date, value, state, 
  observation, payment way, bank, debt collector, and user" do
    pago = Pago.new(entidad_id: 1, documento_id: 1, nropago: 1, fechatrn: "01/01/2018", valor: 20000,
        estado_id: 1, observacion: "Paga mensualidad", forma_pago_id: 1, banco_id: 1, cobrador_id: 1,
        usuario_id: 1)
    expect(pago).to be_valid
  end
  
  it "is invalid without an entity" do
    pago = Pago.new(entidad_id: nil)
    pago.valid?
    expect(pago.errors[:entidad]).to include("can't be blank")
  end

  it "is invalid without a document" do
    pago = Pago.new(documento_id: nil)
    pago.valid?
    expect(pago.errors[:documento]).to include("can't be blank")
  end

  it "is invalid without a payment number" do
    pago = Pago.new(nropago: nil)
    pago.valid?
    expect(pago.errors[:nropago]).to include("can't be blank")
  end

  it "is invalid without a transaction date" do
    pago = Pago.new(fechatrn: nil)
    pago.valid?
    expect(pago.errors[:fechatrn]).to include("can't be blank")
  end

  it "is invalid without a value" do
    pago = Pago.new(valor: nil)
    pago.valid?
    expect(pago.errors[:valor]).to include("can't be blank")
  end

  it "is invalid without a state" do
    pago = Pago.new(estado_id: nil)
    pago.valid?
    expect(pago.errors[:estado]).to include("can't be blank")
  end

  it "is invalid without a payment way" do
    pago = Pago.new(forma_pago_id: nil)
    pago.valid?
    expect(pago.errors[:forma_pago]).to include("can't be blank")
  end

  it "is invalid without a bank" do
    pago = Pago.new(banco_id: nil)
    pago.valid?
    expect(pago.errors[:banco]).to include("can't be blank")
  end

  it "is invalid without an user" do
    pago = Pago.new(usuario_id: nil)
    pago.valid?
    expect(pago.errors[:usuario]).to include("can't be blank")
  end
end
require 'rails_helper'

RSpec.describe Orden, :type => :model do
  it "is valid with a entity, concept, transaction date, expiration date, order number,
  state, observation, technician and user" do
    orden = Orden.new(entidad_id: 1, concepto_id: 1, fechatrn: "01/01/2018", fechaven: "01/01/2018",
        nrorden: 1, estado_id: 1, observacion: "Suscripcion televisión", tecnico_id: 50001, usuario_id: 1)
    expect(orden).to be_valid
  end
  
  it "is invalid without an entity" do
    orden = Orden.new(entidad_id: nil)
    orden.valid?
    expect(orden.errors[:entidad]).to include("can't be blank")
  end

  it "is invalid without a concept" do
    orden = Orden.new(concepto_id: nil)
    orden.valid?
    expect(orden.errors[:concepto]).to include("can't be blank")
  end

  it "is invalid without a transaction date" do
    orden = Orden.new(fechatrn: nil)
    orden.valid?
    expect(orden.errors[:fechatrn]).to include("can't be blank")
  end

  it "is invalid without an expiration date" do
    orden = Orden.new(fechaven: nil)
    orden.valid?
    expect(orden.errors[:fechaven]).to include("can't be blank")
  end

  it "is invalid without an order number" do
    orden = Orden.new(nrorden: nil)
    orden.valid?
    expect(orden.errors[:nrorden]).to include("can't be blank")
  end

  it "is invalid without a state identifier" do
    orden = Orden.new(estado_id: nil)
    orden.valid?
    expect(orden.errors[:estado]).to include("can't be blank")
  end

  it "is invalid without an user" do
    orden = Orden.new(usuario_id: nil)
    orden.valid?
    expect(orden.errors[:usuario]).to include("can't be blank")
  end
end
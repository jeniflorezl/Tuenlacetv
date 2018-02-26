require 'rails_helper'

RSpec.describe Tarifa, :type => :model do
  it "is valid with a zone, concept, plan, value, state and an user" do
    tarifa = Tarifa.new(zona_id: 1, concepto_id: 1, plan_id: 1, valor: '35000', 
    estado_id: 1, usuario_id: 1)
    expect(tarifa).to be_valid
  end

  it "is invalid without a zone" do
    tarifa = Tarifa.new(zona_id: nil)
    tarifa.valid?
    expect(tarifa.errors[:zona]).to include("can't be blank")
  end

  it "is invalid without a concept" do
    tarifa = Tarifa.new(concepto_id: nil)
    tarifa.valid?
    expect(tarifa.errors[:concepto]).to include("can't be blank")
  end

  it "is invalid without a plan" do
    tarifa = Tarifa.new(plan_id: nil)
    tarifa.valid?
    expect(tarifa.errors[:plan]).to include("can't be blank")
  end

  it "is invalid without a value" do
    tarifa = Tarifa.new(valor: nil)
    tarifa.valid?
    expect(tarifa.errors[:valor]).to include("can't be blank")
  end

  it "is invalid without a state" do
    tarifa = Tarifa.new(estado_id: nil)
    tarifa.valid?
    expect(tarifa.errors[:estado]).to include("can't be blank")
  end

  it "is invalid without an user" do
    tarifa = Tarifa.new(usuario_id: nil)
    tarifa.valid?
    expect(tarifa.errors[:usuario]).to include("can't be blank")
  end
end
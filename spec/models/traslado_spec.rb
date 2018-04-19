require 'rails_helper'

RSpec.describe Traslado, :type => :model do
  it "is valid with a order, previous zone, previous neighborhood, previous address,
  new zone, new neighborhood, new address and user" do
    traslado = Traslado.new(orden_id: 1, concepto_id: 1, nrorden: 1, zonaAnt_id: 1,
        barrioAnt_id: 2, direccionAnt: "cll 34 #12-56", zonaNue_id: 1, barrioNue_id: 4, 
        direccionNue: "cr 45 #67-22", usuario_id: 1)
    expect(traslado).to be_valid
  end
  
  it "is invalid without a previous zone" do
    traslado = Traslado.new(zonaAnt_id: nil)
    traslado.valid?
    expect(traslado.errors[:zonaAnt_id]).to include("can't be blank")
  end

  it "is invalid without a previous neighborhood" do
    traslado = Traslado.new(barrioAnt_id: nil)
    traslado.valid?
    expect(traslado.errors[:barrioAnt_id]).to include("can't be blank")
  end

  it "is invalid without a previous address" do
    traslado = Traslado.new(direccionAnt: nil)
    traslado.valid?
    expect(traslado.errors[:direccionAnt]).to include("can't be blank")
  end

  it "is invalid without a new zone" do
    traslado = Traslado.new(zonaNue_id: nil)
    traslado.valid?
    expect(traslado.errors[:zonaNue_id]).to include("can't be blank")
  end

  it "is invalid without a new neighborhood" do
    traslado = Traslado.new(barrioNue_id: nil)
    traslado.valid?
    expect(traslado.errors[:barrioNue_id]).to include("can't be blank")
  end

  it "is invalid without a new address" do
    traslado = Traslado.new(direccionNue: nil)
    traslado.valid?
    expect(traslado.errors[:direccionNue]).to include("can't be blank")
  end

  it "is invalid without an user" do
    traslado = Traslado.new(usuario_id: nil)
    traslado.valid?
    expect(traslado.errors[:usuario]).to include("can't be blank")
  end
end
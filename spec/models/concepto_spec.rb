require 'rails_helper'

RSpec.describe Concepto, :type => :model do
  it "is valid with a service, code, name, abbreviation, iva percentage, operation
  and an user" do
    concepto = Concepto.new(servicio_id: 1, codigo: '52', nombre: 'SUSCRIPCION', 
    abreviatura: 'AFI', porcentajeIva: '19', operacion: '+', usuario_id: 1)
    expect(concepto).to be_valid
  end

  it "is invalid without a service" do
    concepto = Concepto.new(servicio_id: nil)
    concepto.valid?
    expect(concepto.errors[:servicio]).to include("can't be blank")
  end

  it "is invalid without a code" do
    concepto = Concepto.new(codigo: nil)
    concepto.valid?
    expect(concepto.errors[:codigo]).to include("can't be blank")
  end

  it "is invalid without a name" do
    concepto = Concepto.new(nombre: nil)
    concepto.valid?
    expect(concepto.errors[:nombre]).to include("can't be blank")
  end

  it "is invalid without a abbreviation" do
    concepto = Concepto.new(abreviatura: nil)
    concepto.valid?
    expect(concepto.errors[:abreviatura]).to include("can't be blank")
  end

  it "is invalid without a percentage iva" do
    concepto = Concepto.new(porcentajeIva: nil)
    concepto.valid?
    expect(concepto.errors[:porcentajeIva]).to include("can't be blank")
  end

  it "is invalid without an operation" do
    concepto = Concepto.new(operacion: nil)
    concepto.valid?
    expect(concepto.errors[:operacion]).to include("can't be blank")
  end

  it "is invalid without an user" do
    concepto = Concepto.new(usuario_id: nil)
    concepto.valid?
    expect(concepto.errors[:usuario]).to include("can't be blank")
  end
end
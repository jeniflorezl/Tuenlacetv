require 'rails_helper'

RSpec.describe Empresa, :type => :model do
  it "is valid with a type, nit, business name, address, phones, city, entity, logo, email, regime,
  taxpayer, cost center and an user" do
    empresa = Empresa.new(tipo: '01', nit: '900353347', razonsocial: 'enlace informatico s.a.s', 
    direccion: 'cra 47 #53-41', telefono1: '4540312', telefono2: '', ciudad_id: 2, 
    entidad_id: 2, logo: '', correo: 'gerencia@enlaceinformatico.com', regimen: 's', 
    contribuyente: 's', centrocosto: '0001', usuario_id: 1)
    expect(empresa).to be_valid
  end

  it "is invalid without a type" do
    empresa = Empresa.new(tipo: nil)
    empresa.valid?
    expect(empresa.errors[:tipo]).to include("can't be blank")
  end

  it "is invalid without a nit" do
    empresa = Empresa.new(nit: nil)
    empresa.valid?
    expect(empresa.errors[:nit]).to include("can't be blank")
  end

  it "is invalid without a business name" do
    empresa = Empresa.new(razonsocial: nil)
    empresa.valid?
    expect(empresa.errors[:razonsocial]).to include("can't be blank")
  end

  it "is invalid without a address" do
    empresa = Empresa.new(direccion: nil)
    empresa.valid?
    expect(empresa.errors[:direccion]).to include("can't be blank")
  end

  it "is invalid without a phone one" do
    empresa = Empresa.new(telefono1: nil)
    empresa.valid?
    expect(empresa.errors[:telefono1]).to include("can't be blank")
  end

  it "is invalid without a city" do
    empresa = Empresa.new(ciudad_id: nil)
    empresa.valid?
    expect(empresa.errors[:ciudad]).to include("can't be blank")
  end

  it "is invalid without a entity" do
    empresa = Empresa.new(entidad_id: nil)
    empresa.valid?
    expect(empresa.errors[:entidad]).to include("can't be blank")
  end

  it "is invalid without an user" do
    empresa = Empresa.new(usuario_id: nil)
    empresa.valid?
    expect(empresa.errors[:usuario]).to include("can't be blank")
  end
end
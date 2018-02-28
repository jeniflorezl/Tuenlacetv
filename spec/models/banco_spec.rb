require 'rails_helper'

RSpec.describe Banco, :type => :model do
  it "is valid with a nit, name, address, city, phone 1, phone 2, contact, bank account,
  accountant account and an user" do
    banco = Banco.new(nit: '900374273', nombre: 'Caja general', direccion: 'cra 34 #56-34', 
    ciudad_id: 1, telefono1: '3425345', telefono2: '2394839', contacto: '', cuentaBancaria:'',
    cuentaContable: '', usuario_id: 1)
    expect(banco).to be_valid
  end

  it "is invalid without a name" do
    banco = Banco.new(nombre: nil)
    banco.valid?
    expect(banco.errors[:nombre]).to include("can't be blank")
  end

  it "is invalid without a city" do
    banco = Banco.new(ciudad_id: nil)
    banco.valid?
    expect(banco.errors[:ciudad]).to include("can't be blank")
  end

  it "is invalid without an user" do
    banco = Banco.new(usuario_id: nil)
    banco.valid?
    expect(banco.errors[:usuario]).to include("can't be blank")
  end
end
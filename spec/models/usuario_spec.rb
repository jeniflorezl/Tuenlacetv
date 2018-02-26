require 'rails_helper'

RSpec.describe Usuario, :type => :model do
  it "is valid with a login, name, password, level, state, printer type and create user," do
    usuario = Usuario.new(login: 'jorge', nombre: 'jorge lopez',
    password: '123', password_confirmation: '123', nivel: 2,
    estado_id: 1, tipoImpresora: 'l', usuariocre: 'admin')
    expect(usuario).to be_valid
  end

  it "is invalid without a login" do
    usuario = Usuario.new(login: nil)
    usuario.valid?
    expect(usuario.errors[:login]).to include("can't be blank")
  end

  it "is invalid without a name" do
    usuario = Usuario.new(nombre: nil)
    usuario.valid?
    expect(usuario.errors[:nombre]).to include("can't be blank")
  end

  it "is invalid without a password" do
    usuario = Usuario.new(password: nil)
    usuario.valid?
    expect(usuario.errors[:password]).to include("can't be blank")
  end

  it "is invalid without a level" do
    usuario = Usuario.new(nivel: nil)
    usuario.valid?
    expect(usuario.errors[:nivel]).to include("can't be blank")
  end

  it "is invalid without a state" do
    usuario = Usuario.new(estado_id: nil)
    usuario.valid?
    expect(usuario.errors[:estado]).to include("can't be blank")
  end

  it "is invalid without a user" do
    usuario = Usuario.new(usuariocre: nil)
    usuario.valid?
    expect(usuario.errors[:usuariocre]).to include("can't be blank")
  end
end
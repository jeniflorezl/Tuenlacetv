require 'rails_helper'

RSpec.describe Departamento, :type => :model do
  it "is valid with a country, name, code and an user" do
    departamento = Departamento.new(pais_id: 1, nombre: 'risaralda', codigo: '', usuario_id: 1)
    expect(departamento).to be_valid
  end

  it "is invalid without a country" do
    departamento = Departamento.new(pais_id: nil)
    departamento.valid?
    expect(departamento.errors[:pais]).to include("can't be blank")
  end

  it "is invalid without a name" do
    departamento = Departamento.new(nombre: nil)
    departamento.valid?
    expect(departamento.errors[:nombre]).to include("can't be blank")
  end

  it "is invalid without an user" do
    departamento = Departamento.new(usuario_id: nil)
    departamento.valid?
    expect(departamento.errors[:usuario]).to include("can't be blank")
  end
end

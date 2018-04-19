require 'rails_helper'

RSpec.describe Ciudad, :type => :model do
  it "is valid with a country, name, department and an user" do
    ciudad = Ciudad.new(pais_id: 1, nombre: 'barranquilla', usuario_id: 1, departamento_id: 1)
    expect(ciudad).to be_valid
  end

  it "is invalid without a country" do
    ciudad = Ciudad.new(pais_id: nil)
    ciudad.valid?
    expect(ciudad.errors[:pais]).to include("can't be blank")
  end

  it "is invalid without a name" do
    ciudad = Ciudad.new(nombre: nil)
    ciudad.valid?
    expect(ciudad.errors[:nombre]).to include("can't be blank")
  end

  it "is invalid without an user" do
    ciudad = Ciudad.new(usuario_id: nil)
    ciudad.valid?
    expect(ciudad.errors[:usuario]).to include("can't be blank")
  end

  it "is invalid without a department" do
    ciudad = Ciudad.new(departamento_id: nil)
    ciudad.valid?
    expect(ciudad.errors[:departamento]).to include("can't be blank")
  end
end
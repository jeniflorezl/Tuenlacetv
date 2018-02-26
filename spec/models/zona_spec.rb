require 'rails_helper'

RSpec.describe Zona, :type => :model do
  it "is valid with a city, name and an user" do
    zona = Zona.new(ciudad_id: 1, nombre: 'zona general', usuario_id: 1)
    expect(zona).to be_valid
  end

  it "is invalid without a city" do
    zona = Zona.new(ciudad_id: nil)
    zona.valid?
    expect(zona.errors[:ciudad]).to include("can't be blank")
  end

  it "is invalid without a name" do
    zona = Zona.new(nombre: nil)
    zona.valid?
    expect(zona.errors[:nombre]).to include("can't be blank")
  end

  it "is invalid without an user" do
    zona = Zona.new(usuario_id: nil)
    zona.valid?
    expect(zona.errors[:usuario]).to include("can't be blank")
  end
end
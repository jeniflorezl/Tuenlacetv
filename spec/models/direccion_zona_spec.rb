require 'rails_helper'

RSpec.describe DireccionZona, :type => :model do
  it "is valid with a zone, address and an user" do
    direccion_zona = DireccionZona.new(zona_id: 1, direccion: 'calle 10 #45-32', usuario_id: 1)
    expect(direccion_zona).to be_valid
  end

  it "is invalid without a zone" do
    direccion_zona = DireccionZona.new(zona_id: nil)
    direccion_zona.valid?
    expect(direccion_zona.errors[:zona]).to include("can't be blank")
  end

  it "is invalid without an address" do
    direccion_zona = DireccionZona.new(direccion: nil)
    direccion_zona.valid?
    expect(direccion_zona.errors[:direccion]).to include("can't be blank")
  end

  it "is invalid without an user" do
    direccion_zona = DireccionZona.new(usuario_id: nil)
    direccion_zona.valid?
    expect(direccion_zona.errors[:usuario]).to include("can't be blank")
  end
end
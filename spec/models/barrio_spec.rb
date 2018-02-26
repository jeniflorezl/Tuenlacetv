require 'rails_helper'

RSpec.describe Barrio, :type => :model do
  it "is valid with a zone, name and an user" do
    barrio = Barrio.new(zona_id: 1, nombre: 'belen', usuario_id: 1)
    expect(barrio).to be_valid
  end

  it "is invalid without a zone" do
    barrio = Barrio.new(zona_id: nil)
    barrio.valid?
    expect(barrio.errors[:zona]).to include("can't be blank")
  end

  it "is invalid without a name" do
    barrio = Barrio.new(nombre: nil)
    barrio.valid?
    expect(barrio.errors[:nombre]).to include("can't be blank")
  end

  it "is invalid without an user" do
    barrio = Barrio.new(usuario_id: nil)
    barrio.valid?
    expect(barrio.errors[:usuario]).to include("can't be blank")
  end
end
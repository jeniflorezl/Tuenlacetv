require 'rails_helper'

RSpec.describe Entidad, :type => :model do
  it "is valid with a function, person and an user" do
    entidad = Entidad.new(funcion_id: 1, persona_id: 1, usuario_id: 1)
    expect(entidad).to be_valid
  end

  it "is invalid without a function" do
    entidad = Entidad.new(funcion_id: nil)
    entidad.valid?
    expect(entidad.errors[:funcion]).to include("can't be blank")
  end

  it "is invalid without a person" do
    entidad = Entidad.new(persona_id: nil)
    entidad.valid?
    expect(entidad.errors[:persona]).to include("can't be blank")
  end

  it "is invalid without an user" do
    entidad = Entidad.new(usuario_id: nil)
    entidad.valid?
    expect(entidad.errors[:usuario]).to include("can't be blank")
  end
end
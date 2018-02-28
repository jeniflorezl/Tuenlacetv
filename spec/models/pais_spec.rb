require 'rails_helper'

RSpec.describe Pais, :type => :model do
  it "is valid with a name and an user" do
    pais = Pais.new(nombre: 'uruguay', usuario_id: 1)
    expect(pais).to be_valid
  end

  it "is invalid without a name" do
    pais = Pais.new(nombre: nil)
    pais.valid?
    expect(pais.errors[:nombre]).to include("can't be blank")
  end

  it "is invalid without an user" do
    pais = Pais.new(usuario_id: nil)
    pais.valid?
    expect(pais.errors[:usuario]).to include("can't be blank")
  end
end
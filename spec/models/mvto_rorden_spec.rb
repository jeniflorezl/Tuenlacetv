require 'rails_helper'

RSpec.describe MvtoRorden, :type => :model do
  it "is valid with a order registry, order, concept, order number, value,
  and user" do
    mvto_rorden = MvtoRorden.new(registro_orden_id: 1, orden_id: 1, concepto_id: 1, nrorden: 1,
      valor: "01/01/2018", usuario_id: 1)
    expect(mvto_rorden).to be_valid
  end

  it "is invalid without a order registry identifier" do
    mvto_rorden = MvtoRorden.new(registro_orden_id: nil)
    mvto_rorden.valid?
    expect(mvto_rorden.errors[:registro_orden]).to include("can't be blank")
  end

  it "is invalid without a value" do
    mvto_rorden = MvtoRorden.new(valor: nil)
    mvto_rorden.valid?
    expect(mvto_rorden.errors[:valor]).to include("can't be blank")
  end
  
  it "is invalid without an user" do
    mvto_rorden = MvtoRorden.new(usuario_id: nil)
    mvto_rorden.valid?
    expect(mvto_rorden.errors[:usuario]).to include("can't be blank")
  end
end
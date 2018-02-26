require 'rails_helper'

RSpec.describe Plan, :type => :model do
  it "is valid with a service, name and an user" do
    plan = Plan.new(servicio_id: 1, nombre: 'plan television', usuario_id: 1)
    expect(plan).to be_valid
  end

  it "is invalid without a service" do
    plan = Plan.new(servicio_id: nil)
    plan.valid?
    expect(plan.errors[:servicio]).to include("can't be blank")
  end

  it "is invalid without a name" do
    plan = Plan.new(nombre: nil)
    plan.valid?
    expect(plan.errors[:nombre]).to include("can't be blank")
  end

  it "is invalid without an user" do
    plan = Plan.new(usuario_id: nil)
    plan.valid?
    expect(plan.errors[:usuario]).to include("can't be blank")
  end
end
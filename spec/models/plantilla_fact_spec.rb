require 'rails_helper'

RSpec.describe PlantillaFact, :type => :model do
  it "is valid with a entity, concept, state, rate, start date, last date and user" do
    plantilla_fact = PlantillaFact.new(entidad_id: 1, concepto_id: 1, estado_id: 1, 
        tarifa_id: 1, fechaini: "01/01/2018", fechafin: "01/01/2118", usuario_id: 1)
    expect(plantilla_fact).to be_valid
  end
  
  it "is invalid without an entity" do
    plantilla_fact = PlantillaFact.new(entidad_id: nil)
    plantilla_fact.valid?
    expect(plantilla_fact.errors[:entidad]).to include("can't be blank")
  end

  it "is invalid without a concept" do
    plantilla_fact = PlantillaFact.new(concepto_id: nil)
    plantilla_fact.valid?
    expect(plantilla_fact.errors[:concepto]).to include("can't be blank")
  end

  it "is invalid without a state" do
    plantilla_fact = PlantillaFact.new(estado_id: nil)
    plantilla_fact.valid?
    expect(plantilla_fact.errors[:estado]).to include("can't be blank")
  end

  it "is invalid without a rate" do
    plantilla_fact = PlantillaFact.new(tarifa_id: nil)
    plantilla_fact.valid?
    expect(plantilla_fact.errors[:tarifa]).to include("can't be blank")
  end

  it "is invalid without a start date" do
    plantilla_fact = PlantillaFact.new(fechaini: nil)
    plantilla_fact.valid?
    expect(plantilla_fact.errors[:fechaini]).to include("can't be blank")
  end

  it "is invalid without a last date" do
    plantilla_fact = PlantillaFact.new(fechafin: nil)
    plantilla_fact.valid?
    expect(plantilla_fact.errors[:fechafin]).to include("can't be blank")
  end

  it "is invalid without an user" do
    plantilla_fact = PlantillaFact.new(usuario_id: nil)
    plantilla_fact.valid?
    expect(plantilla_fact.errors[:usuario]).to include("can't be blank")
  end
end
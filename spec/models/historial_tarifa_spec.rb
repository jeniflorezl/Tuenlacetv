require 'rails_helper'

RSpec.describe HistorialTarifa, :type => :model do
  it "is valid with a rate, zone, concept, plan, value, start date, expiration date, cost center
  and user" do
    historial_tarifa = HistorialTarifa.new(tarifa_id: 1, zona_id: 1, concepto_id: 1, plan_id: 1,
        valor: 15000, fechainicio: "01/01/2018", fechavence: "30/12/2018", usuario_id: 1)
    expect(historial_tarifa).to be_valid
  end

  it "is invalid without a rate" do
    historial_tarifa = HistorialTarifa.new(tarifa_id: nil)
    historial_tarifa.valid?
    expect(historial_tarifa.errors[:tarifa]).to include("can't be blank")
  end

  it "is invalid without a zone" do
    historial_tarifa = HistorialTarifa.new(zona_id: nil)
    historial_tarifa.valid?
    expect(historial_tarifa.errors[:zona]).to include("can't be blank")
  end

  it "is invalid without a concept" do
    historial_tarifa = HistorialTarifa.new(concepto_id: nil)
    historial_tarifa.valid?
    expect(historial_tarifa.errors[:concepto]).to include("can't be blank")
  end

  it "is invalid without a plan" do
    historial_tarifa = HistorialTarifa.new(plan_id: nil)
    historial_tarifa.valid?
    expect(historial_tarifa.errors[:plan]).to include("can't be blank")
  end

  it "is invalid without a value" do
    historial_tarifa = HistorialTarifa.new(valor: nil)
    historial_tarifa.valid?
    expect(historial_tarifa.errors[:valor]).to include("can't be blank")
  end

  it "is invalid without a start date" do
    historial_tarifa = HistorialTarifa.new(fechainicio: nil)
    historial_tarifa.valid?
    expect(historial_tarifa.errors[:fechainicio]).to include("can't be blank")
  end

  it "is invalid without a expiration date" do
    historial_tarifa = HistorialTarifa.new(fechavence: nil)
    historial_tarifa.valid?
    expect(historial_tarifa.errors[:fechavence]).to include("can't be blank")
  end

  it "is invalid without an user" do
    historial_tarifa = HistorialTarifa.new(usuario_id: nil)
    historial_tarifa.valid?
    expect(historial_tarifa.errors[:usuario]).to include("can't be blank")
  end
end
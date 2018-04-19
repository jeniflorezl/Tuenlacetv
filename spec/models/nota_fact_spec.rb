require 'rails_helper'

RSpec.describe NotaFact, :type => :model do
  it "is valid with a zona identifier, elaboration date, starting date, last date, expiration date,
  cut date, expired payments date and user" do
    nota_fact = NotaFact.new(zona_id: 1, fechaElaboracion: "01/01/2018", fechaInicio: "01/01/2018",
        fechaFin: "30/12/2018", fechaVencimiento: "30/12/2018", fechaCorte: "30/12/2018",
        fechaPagosVen: "30/12/2018", usuario_id: 1)
    expect(nota_fact).to be_valid
  end

  it "is invalid without an elaboration date" do
    nota_fact = NotaFact.new(fechaElaboracion: nil)
    nota_fact.valid?
    expect(nota_fact.errors[:fechaElaboracion]).to include("can't be blank")
  end

  it "is invalid without a starting date" do
    nota_fact = NotaFact.new(fechaInicio: nil)
    nota_fact.valid?
    expect(nota_fact.errors[:fechaInicio]).to include("can't be blank")
  end

  it "is invalid without a last date" do
    nota_fact = NotaFact.new(fechaFin: nil)
    nota_fact.valid?
    expect(nota_fact.errors[:fechaFin]).to include("can't be blank")
  end

  it "is invalid without an expiration date" do
    nota_fact = NotaFact.new(fechaVencimiento: nil)
    nota_fact.valid?
    expect(nota_fact.errors[:fechaVencimiento]).to include("can't be blank")
  end

  it "is invalid without a cut date" do
    nota_fact = NotaFact.new(fechaCorte: nil)
    nota_fact.valid?
    expect(nota_fact.errors[:fechaCorte]).to include("can't be blank")
  end

  it "is invalid without an expired payments date" do
    nota_fact = NotaFact.new(fechaPagosVen: nil)
    nota_fact.valid?
    expect(nota_fact.errors[:fechaPagosVen]).to include("can't be blank")
  end
  
  it "is invalid without an user" do
    nota_fact = NotaFact.new(usuario_id: nil)
    nota_fact.valid?
    expect(nota_fact.errors[:usuario]).to include("can't be blank")
  end
end
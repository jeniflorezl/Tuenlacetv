require 'rails_helper'

RSpec.describe Persona, :type => :model do
  it "is valid with a type document, document, names, last names, address, neighborhood,
  zone, city, phones, email, birthdate, type person, stratum, physical condition and an user" do
    persona = Persona.new(tipo_documento_id: 1, documento: '7447852522', nombre1: 'ESTEFANIA', 
    nombre2: '', apellido1: 'FLÓREZ', apellido2: 'LONDOÑO', direccion: 'Cra 47 #53-41', 
    barrio_id: 2, zona_id: 1, telefono1: '4540312', telefono2: '',  
    correo: 'jeniferfl@gmail.com', fechanac: '13/07/1995', tipopersona: 'N', estrato: '3', 
    condicionfisica: 'N', usuario_id: 1)
    expect(persona).to be_valid
  end
  
  it "is invalid without a type document" do
    persona = Persona.new(tipo_documento_id: nil)
    persona.valid?
    expect(persona.errors[:tipo_documento]).to include("can't be blank")
  end

  it "is invalid without a document" do
    persona = Persona.new(documento: nil)
    persona.valid?
    expect(persona.errors[:documento]).to include("can't be blank")
  end

  it "is invalid without a first name" do
    persona = Persona.new(nombre1: nil)
    persona.valid?
    expect(persona.errors[:nombre1]).to include("can't be blank")
  end

  it "is invalid without a first last name" do
    persona = Persona.new(apellido1: nil)
    persona.valid?
    expect(persona.errors[:apellido1]).to include("can't be blank")
  end

  it "is invalid without a neighborhood" do
    persona = Persona.new(barrio_id: nil)
    persona.valid?
    expect(persona.errors[:barrio]).to include("can't be blank")
  end

  it "is invalid without a zone" do
    persona = Persona.new(zona_id: nil)
    persona.valid?
    expect(persona.errors[:zona]).to include("can't be blank")
  end

  it "is invalid without a type person" do
    persona = Persona.new(tipopersona: nil)
    persona.valid?
    expect(persona.errors[:tipopersona]).to include("can't be blank")
  end

  it "is invalid without a physical condition" do
    persona = Persona.new(condicionfisica: nil)
    persona.valid?
    expect(persona.errors[:condicionfisica]).to include("can't be blank")
  end

  it "is invalid without an user" do
    persona = Persona.new(usuario_id: nil)
    persona.valid?
    expect(persona.errors[:usuario]).to include("can't be blank")
  end
end
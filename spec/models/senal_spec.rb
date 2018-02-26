require 'rails_helper'

RSpec.describe Senal, :type => :model do
  it "is valid with a entity, service, contract, address, urbanization,
  tower, apartment, neighborhood, zone, phones, contact, stratum, type living place,
  observation, state, contract date, permanence, amount tv, amount decoder, precinto, 
  seller, type of installation, technology, type of service, installation area
  and an user" do
    senal = Senal.new(entidad_id: 1, servicio_id: 1, contrato: '4789963', direccion: 'Calle 11 #24-23', 
    urbanizacion: '', torre: '', apto: '', barrio_id: 1, zona_id: 1, telefono1: '4540312', telefono2: '',
    contacto: '', estrato: '4', vivienda: 'P', observacion: '', estado_id: 1, fechacontrato: '01/01/2017',
    permanencia: '', televisores: 2, decos: '', precinto: '12321', vendedor_id: 5, tipo_instalacion_id: 1,
    tecnologia_id: 1, tiposervicio: 'residencial', areainstalacion: 'urbana', usuario_id: 1)
    expect(senal).to be_valid
  end
  
  it "is invalid without a entity" do
    senal = Senal.new(entidad_id: nil)
    senal.valid?
    expect(senal.errors[:entidad]).to include("can't be blank")
  end

  it "is invalid without a service" do
    senal = Senal.new(servicio_id: nil)
    senal.valid?
    expect(senal.errors[:servicio]).to include("can't be blank")
  end

  it "is invalid without a contract" do
    senal = Senal.new(contrato: nil)
    senal.valid?
    expect(senal.errors[:contrato]).to include("can't be blank")
  end

  it "is invalid without a address" do
    senal = Senal.new(direccion: nil)
    senal.valid?
    expect(senal.errors[:direccion]).to include("can't be blank")
  end

  it "is invalid without a phone one" do
    senal = Senal.new(telefono1: nil)
    senal.valid?
    expect(senal.errors[:telefono1]).to include("can't be blank")
  end

  it "is invalid without a neighborhood" do
    senal = Senal.new(barrio_id: nil)
    senal.valid?
    expect(senal.errors[:barrio]).to include("can't be blank")
  end

  it "is invalid without a zone" do
    senal = Senal.new(zona_id: nil)
    senal.valid?
    expect(senal.errors[:zona]).to include("can't be blank")
  end

  it "is invalid without a state" do
    senal = Senal.new(estado_id: nil)
    senal.valid?
    expect(senal.errors[:estado]).to include("can't be blank")
  end

  it "is invalid without a contract date" do
    senal = Senal.new(fechacontrato: nil)
    senal.valid?
    expect(senal.errors[:fechacontrato]).to include("can't be blank")
  end

  it "is invalid without a type of installation" do
    senal = Senal.new(tipo_instalacion_id: nil)
    senal.valid?
    expect(senal.errors[:tipo_instalacion]).to include("can't be blank")
  end

  it "is invalid without a technology" do
    senal = Senal.new(tecnologia_id: nil)
    senal.valid?
    expect(senal.errors[:tecnologia]).to include("can't be blank")
  end

  it "is invalid without an user" do
    senal = Senal.new(usuario_id: nil)
    senal.valid?
    expect(senal.errors[:usuario]).to include("can't be blank")
  end
end
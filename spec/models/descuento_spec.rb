require 'rails_helper'

RSpec.describe Descuento, :type => :model do
  it "is valid with a payment, discount and user" do
    descuento = Descuento.new(pago_id: 1, doc_pagos_id: 3, nropago: 1, dcto_id: 1, 
        doc_dctos_id: 1, nrodcto: 1, usuario_id: 1)
    expect(descuento).to be_valid
  end

  it "is invalid without an user" do
    descuento = Descuento.new(usuario_id: nil)
    descuento.valid?
    expect(descuento.errors[:usuario]).to include("can't be blank")
  end
end
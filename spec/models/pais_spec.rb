require 'rails_helper'

RSpec.describe Pais, :type => :model do
  it "is valid with a name and an user" do
    pais = Pais.new(nombre: 'uruguay', usuario_id: 1)
    expect(pais).to be_valid
  end
end
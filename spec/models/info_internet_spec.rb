require 'rails_helper'

RSpec.describe InfoInternet, :type => :model do
  it "is valid with a ip address, speed, macs, modem serial, modem brand, subnet mask
  dns, gateway, node, password wifi, equipment an user" do
    info_internet = InfoInternet.new(senal_id: 1, direccionip: '127.0.0.1', velocidad: 3, mac1: '168.0.0.125', 
    mac2: '168.0.0.125', serialm: '', marcam: '', mascarasub: '127.0.25.56', dns: '168.0.0.125',
    gateway: '168.0.0.125', nodo: 1, clavewifi: '1223334555', equipo: 's', usuario_id: 1)
    expect(info_internet).to be_valid
  end

  it "is invalid without an user" do
    info_internet = InfoInternet.new(usuario_id: nil)
    info_internet.valid?
    expect(info_internet.errors[:usuario]).to include("can't be blank")
  end
end
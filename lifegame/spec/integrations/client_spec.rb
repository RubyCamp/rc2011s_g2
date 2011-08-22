require "spec_helper"
require "drb/drb"

uri = "druby://127.0.0.1:3000"
DRb.start_service(uri, Server.new)
client0 = Client.new(uri)
client1 = Client.new(uri)

describe "Client" do
  it "has connection to server" do
    client0.server.should be_true
  end

  it "has different player_id" do
    client0.player_id.should_not == client1.player_id
  end
end

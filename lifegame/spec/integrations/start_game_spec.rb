require "spec_helper"

uri = "druby://127.0.0.1:3000"
server = Server.new
DRb.start_service(uri, server)
client1 = Client.new(uri)
client2 = Client.new(uri)
Thread.new { server.start_loop }
Thread.new { client1.start_loop }
Thread.new { client2.start_loop }

describe "Start Game" do
  it "start game" do
    server = DRbObject.new_with_uri(uri)
    server.is_start?.should be_true
  end

  it "get game turn" do
    server = DRbObject.new_with_uri(uri)
    server.game_data[:turn].should be_true
    client1.data[:turn].should be_true
    client2.data[:turn].should be_true
  end

  it "validate max player count" do
    lambda { 3.times { Client.new(uri)} }.should raise_error
  end

  it "deliver server data to client" do
    sleep 60
    client1.data.should_not == nil
  end
end

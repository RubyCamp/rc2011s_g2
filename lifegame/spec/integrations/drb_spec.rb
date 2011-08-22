require "spec_helper"

describe "DRb" do
  before do
    require "drb/drb"
    uri = "druby://127.0.0.1:3000"
    DRb.start_service(uri, Server.new)
    @server = DRbObject.new_with_uri(uri)
  end

  it "access server" do
    @server.should be_true
  end
end

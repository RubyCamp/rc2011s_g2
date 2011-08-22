#!/usr/bin/env ruby

require "dxruby"
require "drb/drb"

$:.unshift(File.expand_path("../../lib", __FILE__)) if $0 == __FILE__
require "server"
require "field"
require "game"
require "creature"

uri = ARGV.shift || 'druby://127.0.0.1:3000'
server = Server.new
DRb.start_service(uri, server)
server.start_loop

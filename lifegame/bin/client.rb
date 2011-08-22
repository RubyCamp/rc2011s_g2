#!/usr/bin/env ruby

require "dxruby"
require "drb/drb"

$:.unshift(File.expand_path("../../lib", __FILE__)) if $0 == __FILE__
require "window_ext"
require "player"
require "client"
require "server"
require "field"
require "game"
require "creature"

client = Client.new("druby://127.0.0.1:3000")
client.start_loop

require "drb/drb"
require "pp"

Thread.abort_on_exception = true

$:.unshift(File.expand_path("../../lib", __FILE__)) if $0 == __FILE__
require "player"
require "client"
require "server"
require "field"
require "game"
require "creature"

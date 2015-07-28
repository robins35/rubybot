#!/usr/bin/env ruby

require_relative 'environment'
require_relative 'lib/mixins/message_manager'

class Bot
  include MessageManager

  def initialize(server, port, channel, nick)
    @channel = channel
    @socket = TCPSocket.open(server, port)
    say "NICK #{nick}"
    say "USER #{nick.downcase} 0 * #{nick.downcase}"
    say "JOIN ##{@channel}"
    say_to_chan "PAPPA DOC"
  end

  def say(msg)
    puts msg
    @socket.puts msg
  end

  def say_to_chan(msg)
    return if msg.nil?
    msg.split("\r\n").each do |m|
      say "PRIVMSG ##{@channel} :#{m}"
    end
  end

  def run
    until @socket.eof? do
      msg = @socket.gets
      puts msg

      parse_message msg
    end
  end

  def quit
    say "PART ##{@channel} :BYE, BYE Y'ALL"
    say 'QUIT'
  end
end

bot = Bot.new("irc.freenode.net", 6667, 'ppdloc', 'anus_bot')

trap("INT"){ bot.quit }

bot.run

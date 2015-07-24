#!/usr/bin/env ruby

require_relative 'environment'
require 'socket'
require 'pry'

class Bot
  def initialize(server, port, channel)
    @channel = channel
    @socket = TCPSocket.open(server, port)
    say "NICK Scriptobaut"
    say "USER scriptobaut 0 * scriptobaut"
    say "JOIN ##{@channel}"
    say_to_chan "PAPPA DOC"
  end

  def say(msg)
    puts msg
    @socket.puts msg
  end

  def say_to_chan(msg)
    say "PRIVMSG ##{@channel} :#{msg}"
  end

  def run
    until @socket.eof? do
      msg = @socket.gets
      puts msg

      if msg.match(/^PING :(.*)$/)
        say "PONG #{$~[1]}"
        next
      end

      if msg.match(/PRIVMSG ##{@channel} :(.*)$/)
        content = $~[1].strip

        if m = content.match(/^!(\w*) (.*)/)
          case m[1]
          when "seen"
            say_to_chan "I saw that guy #{m[2]} like 5 minute ago"
          else
            say_to_chan "#{m[1]} hasn't been implemented yet"
          end
        end
      end
    end
  end

  def quit
    say "PART ##{@channel} :BYE, BYE Y'ALL"
    say 'QUIT'
  end
end

bot = Bot.new("irc.freenode.net", 6667, 'ppdloc')

trap("INT"){ bot.quit }

#bot.run

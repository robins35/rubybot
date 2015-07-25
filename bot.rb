#!/usr/bin/env ruby

require_relative 'environment'
require 'socket'


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

      if msg.match(/^:(\w*)!.*PRIVMSG ##{@channel} :(.*)$/)
        user_name = $~[1].downcase
        content = $~[2].strip

        if (user = User.where(name: user_name)).nil?
          user = User.create(name: user_name) if user.nil?
        end


        if command_match = content.match(/^!(\w*) (.*)/)
          case command_match[1]
          when "seen"
            message = user.messages.last
            if message.blank?
              say_to_chan "I have never seen #{user_name}"
            else
              say_to_chan
            end
          else
            say_to_chan "#{command_match[1]} hasn't been implemented yet"
          end
        else
          Message.create(user: user, text: content)
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

bot.run

require_relative '../command'

module MessageManager
  include Command

  def parse_message msg
    if msg.match(/^PING :(.*)$/)
      say "PONG #{$~[1]}"
    elsif msg.match(/^:(\w*)!.*PRIVMSG ##{@channel} :(.*)$/)
      author_name = $~[1].downcase
      content = $~[2].strip

      if (author = User.where(name: author_name).first).blank?
        author = User.create(name: author_name)
      end

      if command_match = content.match(/^!(\w*) ?(.*)/)
        args = command_match[2]
        case command_match[1]
        when "seen"
          execute_command :seen, args
        when "goaway"
          quit
        else
          say_to_chan "#{command_match[1]} hasn't been implemented yet"
        end
      end
      Message.create(user: author, text: content, message_type: 'message')
    elsif activity_match = msg.match(/^:(\w*)!.*(JOIN|QUIT|PART) [##{@channel}|:Client Quit]/)
      author_name = $~[1].downcase
      if (author = User.where(name: author_name).first).blank?
        author = User.create(name: author_name)
      end
      activity = $~[2].downcase
      message = Message.new(user: author, text: content, message_type: activity)
      if !message.save
        puts "\nERROR: Could not save activity message with activity: #{activity}\n"
      end
    end
  end
end

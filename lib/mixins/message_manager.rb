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

      check_pending_messages author.id

      if command_match = content.match(/^!(\w*)[\ |\/]?(.*)/)
        args = command_match[2]
        case command_match[1]
        when "booty"
          execute_command :booty, args
        when "pussy"
          execute_command :pussy, args
        when "bpt"
          execute_command :black_people_twitter, args
        when "s"
          execute_command :sed, "#{author.id}/#{args}"
        when "seen"
          execute_command :seen, args
        when "tell"
          execute_command :tell, "#{author.id} #{args}"
        when "goaway"
          quit
        when "xkcd"
          if args.blank?
            execute_command :xkcd, args
          else
            execute_command :xkcd_search, args
          end
        else
          say_to_chan "#{command_match[1]} hasn't been implemented yet"
        end
      end
      Message.create(user: author, text: content, message_type: 'message')
    elsif activity_match = msg.match(/^:(\w*)!.*(JOIN|QUIT|PART) [##{@channel}|:Client Quit]/)
      author_name = $~[1].downcase
      action = $~[2]
      if (author = User.where(name: author_name).first).blank?
        author = User.create(name: author_name)
      end

      check_pending_messages author.id if action == 'JOIN'

      activity = $~[2].downcase
      message = Message.new(user: author, text: content, message_type: activity)
      if !message.save
        puts "\nERROR: Could not save activity message with activity: #{activity}\n"
      end
    end
  end
end

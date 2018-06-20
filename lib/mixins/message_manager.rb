require_relative '../command'
require 'pry'

module MessageManager

  def parse_message msg
    if msg.match(/^PING :(.*)$/)
      say "PONG #{$~[1]}"
    elsif msg.match(/^:(\w*)!.*PRIVMSG #{@channel} :(.*)$/)
      author_name = $~[1].downcase
      content = $~[2].strip

      if (author = User.where(name: author_name).first).blank?
        author = User.create(name: author_name)
      end

      say_to_chan Command::check_pending_messages author.id
      say_to_chan Command::summarize_any_urls content

      if command_match = content.match(/^!(\w*)[\ |\/]?(.*)/)

        args = command_match[2]
        case command_match[1]
        when "imgur"
          args_match = args.match(/^(add|remove|list|clear) ?(\w*) ?(\w*)/)
          return if args_match.nil?
          imgur_command = args_match[1]
          if imgur_command == "list"
            say_to_chan Command::execute_command(:imgur_list)
          else
            command_name = args_match[2]
            if imgur_command == "add"
              subimgur = args_match[3]
              say_to_chan Command::execute_command(:imgur_add,"#{command_name} #{subimgur}")
            elsif imgur_command == "remove"
              say_to_chan Command::execute_command(:imgur_remove, command_name)
            elsif imgur_command == "clear"
              say_to_chan Command::execute_command(:imgur_clear)
            end
          end
        when "s"
          say_to_chan Command::execute_command :sed, "#{author.id}/#{args}"
        when "tell"
          say_to_chan Command::execute_command :tell, "#{author.id} #{args}"
        when "goaway"
          quit
        when "xkcd"
          if args.blank?
            say_to_chan Command::execute_command :xkcd
          else
            say_to_chan Command::execute_command :xkcd_search, args
          end
        else
          say_to_chan Command::execute_command command_match[1].to_sym, args
        end
      end
      Message.create(user: author, text: content, message_type: 'message')
    elsif activity_match = msg.match(/^:(\w*)!.*(JOIN|QUIT|PART) [#{@channel}|:Client Quit]/)
      author_name = $~[1].downcase
      action = $~[2]
      if (author = User.where(name: author_name).first).blank?
        author = User.create(name: author_name)
      end

      say_to_chan Command::check_pending_messages author.id if action == 'JOIN'

      activity = $~[2].downcase
      message = Message.new(user: author, text: content, message_type: activity)
      if !message.save
        puts "\nERROR: Could not save activity message with activity: #{activity}\n"
      end
    end
  end
end

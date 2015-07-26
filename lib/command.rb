require 'pry'

module Command

  def execute_command command, args
    puts "TEST"
    self.send(command, args)
  end

  private

    def seen args
      user_name = args.split.first.downcase
      if (user = User.where(name: user_name).first).blank?
        user = User.create(name: user_name)
      end
      message = user.messages.last
      if message.blank?
        say_to_chan "I have never seen #{user_name}"
      else
        case message.message_type
        when 'message'
          say_to_chan "I last saw #{user.name} #{time_ago_in_words message.created_at} ago saying: \"#{message.text}\"."
        when 'join', 'quit', 'part'
          say_to_chan "I last saw #{user.name} #{time_ago_in_words message.created_at} ago #{message.message_type}ing."
        else
          say_to_chan "I last saw #{user.name} #{time_ago_in_words message.created_at} ago doing an unknown activity."
        end
      end
    end
end

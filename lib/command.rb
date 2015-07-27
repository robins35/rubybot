require 'pry'
require_relative 'imgur'
require_relative 'xkcd_manager'

module Command

  def execute_command command, args
    self.send(command, args)
  end

  def check_pending_messages recipient_id
    u = User.find(recipient_id)
    pms = u.pending_messages
    pms.each do |pm|
      recipient = pm.user
      text = pm.text
      say_to_chan "#{recipient.name}, #{time_ago_in_words pm.created_at} ago #{pm.author.name} wrote you the following message: \"#{text}\"."
      pm.destroy
    end
  end

  private

    def booty args
      say_to_chan Imgur::booty
    end

    def pussy args
      say_to_chan Imgur::pussy
    end

    def black_people_twitter args
      say_to_chan Imgur::black_people_twitter
    end

    def sed args
      author_id, search, replace = args.split '/'
      return if !(author_id && search && replace)
      message = Message.where.not(user_id: author_id).where(message_type: 'message').order(:created_at).last
      new_message = message.text.gsub(search, replace)
      say_to_chan "#{message.user.name}: #{new_message}"
    end

    def seen args
      return if args.blank?
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

    def tell args
      tell_match = args.match(/^(\d+) (\w+) (.+)/)
      return if tell_match.blank?
      author_id = tell_match[1]
      recipient_name = tell_match[2].downcase
      message_text = tell_match[3]
      if (recipient = User.where(name: recipient_name).first).blank?
        recipient = User.create(name: recipient_name)
      end

      pm = PendingMessage.new(user: recipient, author_id: author_id, text: message_text)
      if !pm.save
        puts "\nERROR: Could not save PendingMessage\n"
      end
    end

    def xkcd args
      say_to_chan XkcdManager::random_image
    end

    def xkcd_search args
      say_to_chan XkcdManager::search_image args
    end
end

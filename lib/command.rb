require 'pry'
require_relative 'xkcd_manager'

module Command

  extend ActionView::Helpers::DateHelper

  def self.execute_command command, args = ""
    if args.present?
      self.send(command, args)
    else
      self.send command
    end
  end

  def self.check_pending_messages recipient_id
    u = User.find(recipient_id)
    pms = u.pending_messages
    chan_output = ''
    pms.each do |pm|
      recipient = pm.user
      text = pm.text
      chan_output += "#{recipient.name}, #{time_ago_in_words pm.created_at} ago #{pm.author.name} wrote you the following message: \"#{text}\".\r\n"
      pm.destroy
    end
    chan_output
  end

  def self.method_missing method_sym, *arguments, &block
    imgur_command = ImgurCommand.where(command: method_sym.to_s).first
    if imgur_command.nil?
      return "Command #{method_sym.to_s} doesn't exist"
    end
    imgur_command.get_random_from_subimgur
  end

  private

    def self.imgur_add args
      return "Wrong format" if args.blank?
      command, subimgur  = args.split
      subimgur = command if subimgur.nil?
      imgur_command = ImgurCommand.new(command: command, subimgur: subimgur)
      if imgur_command.save
        "Successfully added command #{command}"
      else
        "ERROR: Couldn't save ImgurCommand"
      end
    end

    def self.imgur_remove args
      return "Wrong format" if args.blank?
      if (imgur_command = ImgurCommand.where(command: args).first).nil?
        return "Command !#{args} doesn't exist"
      end
      binding.pry
      imgur_command.destroy
      "Removed command !#{args}"
    end

    def self.imgur_list
      ImgurCommand.all.map do |imgur_command|
        "!#{imgur_command.command} - returns random from #{imgur_command.full_subimgur_url}"
      end.join("\r\n")
    end

    def self.sed args
      author_id, search, replace = args.split '/'
      return if !(author_id && search && replace)
      message = Message.where.not(user_id: author_id).where(message_type: 'message').order(:created_at).last
      new_message = message.text.gsub(search, replace)
      "#{message.user.name}: #{new_message}"
    end

    def self.seen args
      return if args.blank?
      user_name = args.split.first.downcase
      if (user = User.where(name: user_name).first).blank?
        user = User.create(name: user_name)
      end
      message = user.messages.last
      if message.blank?
        "I have never seen #{user_name}"
      else
        case message.message_type
        when 'message'
          "I last saw #{user.name} #{time_ago_in_words message.created_at} ago saying: \"#{message.text}\"."
        when 'join', 'quit', 'part'
          "I last saw #{user.name} #{time_ago_in_words message.created_at} ago #{message.message_type}ing."
        else
          "I last saw #{user.name} #{time_ago_in_words message.created_at} ago doing an unknown activity."
        end
      end
    end

    def self.tell args
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

    def self.xkcd args
      XkcdManager::random_image
    end

    def self.xkcd_search args
      XkcdManager::search_image args
    end
end

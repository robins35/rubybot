require 'active_record'

class User < ActiveRecord::Base
  has_many :messages
  has_many :pending_messages

  def messages
    Message.where(user_id: id)
  end

  def pending_message
    PendingMessage.where(user_id: id)
  end
end

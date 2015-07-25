require 'active_record'

class User < ActiveRecord::Base
  has_many :messages

  def messages
    Message.where(user_id: id)
  end
end

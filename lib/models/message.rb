require 'active_record'

class Message < ActiveRecord::Base
  belongs_to :user

  MESSAGE_TYPES = %w( message join quit part )

  validates_inclusion_of :message_type, in: MESSAGE_TYPES
end

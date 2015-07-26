require 'active_record'

class PendingMessage < ActiveRecord::Base
  belongs_to :user

  def author
    User.find(author_id)
  end
end

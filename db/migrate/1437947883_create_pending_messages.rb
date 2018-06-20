# 1437947883_create_pending_messages.rb
require_relative '../../environment'

class CreatePendingMessages < ActiveRecord::Migration[5.0]

  def change
    create_table :pending_messages do |t|
      t.belongs_to  :user, index: true, null: false
      t.integer     :author_id, index: true, null: false
      t.text        :text, null: false

      t.timestamps null: true
    end
  end

end

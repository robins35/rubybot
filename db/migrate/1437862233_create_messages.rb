# 1437862233_create_messages.rb
require_relative '../../environment'

class CreateMessages < ActiveRecord::Migration[5.0]

  def change
    create_table :messages do |t|
      t.belongs_to  :user, index: true, null: false
      t.text        :text
      t.string      :message_type

      t.timestamps null: true
    end
  end

end

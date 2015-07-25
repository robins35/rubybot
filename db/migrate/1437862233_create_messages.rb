# 1437862233_create_messages.rb
require_relative '../../environment'

class CreateMessages < ActiveRecord::Migration

  def change
    create_table :messages do |t|
      t.belongs_to  :user, index: true, null: false
      t.text        :text, null: false

      t.timestamps null: true
    end
  end

end

# 1438052089_create_imgur_commands.rb
require_relative '../../environment'

class CreateImgurCommands < ActiveRecord::Migration[5.0]

  def change
    create_table :imgur_commands do |t|
      t.string  :command, null: false
      t.string  :subimgur, null: false

      t.timestamps null: true
    end
  end

end

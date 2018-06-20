# 1437784429_add_table_users.rb
require_relative '../../environment'

class CreateUsers < ActiveRecord::Migration[5.0]

  def change
    create_table :users do |t|
      t.string  :name

      t.timestamps null: true
    end
  end

end

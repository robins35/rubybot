require 'pry'

namespace :g do
  def migration_name name
    binding.pry
  end

  task :environment do
    MIGRATIONS_DIR = ENV['MIGRATIONS_DIR'] || '../../db/migrate'
  end

  desc "Make a new migration file with timestamp prepended"
  task :migration, [:name] => :environment do |name|
    file_name = File.join(MIGRATIONS_DIR, migration_name(name))
    File.open(file_name, 'w') do |f|

    end
  end
end

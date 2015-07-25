require 'active_record'
require 'awesome_print'
require 'pry'
require 'yaml'
require 'rake'

Dir.glob('./lib/*').each do |folder|
  Dir.glob(folder +"/*.rb").each do |file|
    require file
  end
end

app = Rake.application
app.init
app.add_import 'lib/tasks/db.rake'
app.load_rakefile
app['db:configure_connection'].invoke

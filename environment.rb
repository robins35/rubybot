require 'active_record'
require 'active_support'
require 'awesome_print'
require 'pry'
require 'yaml'
require 'rake'

app = Rake.application
app.init
app.add_import 'lib/tasks/db.rake'
app.load_rakefile
app['db:configure_connection'].invoke

Dir.glob('./lib/*').each do |folder|
  Dir.glob(folder +"/*.rb").each do |file|
    require file
  end
end

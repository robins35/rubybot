require 'active_record'
require 'active_support'
require 'active_support/all'
require 'action_view'
require 'action_view/helpers'
require 'awesome_print'
require 'pry'
require 'yaml'
require 'rake'
require 'socket'

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

require 'rails/generators'
require 'rails/generators/migration'
module Governor
  class MigrateGenerator < Rails::Generators::Base
    include Rails::Generators::Migration
    source_root File.expand_path('../templates', __FILE__)
  
    def self.next_migration_number(dirname)
      if ActiveRecord::Base.timestamped_migrations
        Time.new.utc.strftime("%Y%m%d%H%M%S")
      else
        "%.3d" % (current_migration_number(dirname) + 1)
      end
    end
  
    def create_migration_file
      migration_template 'migrations/create_articles.rb', 'db/migrate/create_articles.rb', :skip => true
      PluginManager.plugins.each do |plugin|
        plugin.migrations.each do |migration|
          sleep 1 # advance the file name
          migration_template File.expand_path(migration), "db/migrate/#{File.basename(migration)}", :skip => true
        end
      end
    end
  end
end
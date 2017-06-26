module EctShares
  module Generators
    class InstallGenerator < Rails::Generators::Base
      include Rails::Generators::Migration

      source_root File.expand_path('../../templates', __FILE__)
      desc 'Sets up the ECT Shares Configuration File'

      # copy migration
      def create_migration_file
        migration_template 'migration_ect_shares_share.rb', 'db/migrate/create_ect_shares_share.rb'
      end
    end
  end
end

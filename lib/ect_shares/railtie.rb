require 'rails'

module EctShares
  class Railtie < Rails::Railtie
    railtie_name :ect_shares

    rake_tasks do
      load "tasks/ect_shares.rake"
    end
  end
end

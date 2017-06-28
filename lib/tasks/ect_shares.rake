require 'ect_shares'
require 'fileutils'

namespace :ect_shares do
  desc 'Import the CSV file provided (append)'
  task :import_csv => :environment do
    path = "db/import/"
    error_filename  = "#{path}ect_shares_errors.log"
    data_filename = "#{path}ect_shares.csv"
    csv = File.read(data_filename)
    json = csv_to_json(csv)
    json.each do |record|
      attrs = map_import_to_model_attrs(record)
      share = EctShares::Share.new(attrs)
    end
  end

  desc 'Clear out share information'
  task :clear => :environment do
    puts "Clearing existing ECT Shares records (#{EctShares::Share.count})"
    EctShares::Share.delete_all
  end

end

# map the json fields to an attribute hash for a Share model
def map_import_to_model_attrs(record)
  p record
  {}
end

def csv_to_json(csv)
  csv = CSV.new(csv, headers: true, header_converters: :symbol, converters: :all)
  csv.to_a.map {|row| row.to_hash }
end

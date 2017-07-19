require 'ect_shares'
require 'fileutils'

namespace :ect_shares do
  desc 'Import the CSV file provided (append)'
  task :import_csv => :environment do
    path = "db/import/"
    error_filename  = "#{path}ect_shares_errors.log"
    data_filename = "#{path}ect_shares.csv"
    puts "Importing ECT share records from #{data_filename}"

    puts "... removing existing records (#{EctShares::Share.count})"
    Rake::Task['ect_shares:clear'].invoke

    json = csv_to_json(File.read(data_filename))
    puts "... processing #{json.size} records"
    json.each do |record|
      attrs = map_import_to_model_attrs(record)
      share = EctShares::Share.new(attrs)
      if share.valid?
        begin
          share.save
        rescue e
          puts "Unexpected errror: #{e}"
          puts "share data: #{record}"
        end
      else
        puts "Invalid share record: #{record}"
      end
    end
    puts "... complete: (#{EctShares::Share.count}) record in database"
  end

  desc 'Clear out share information'
  task :clear => :environment do
    puts "Clearing existing ECT Shares records (#{EctShares::Share.count})"
    EctShares::Share.delete_all
  end

end

# map the json fields to an attribute hash for a Share model
def map_import_to_model_attrs(record)
  {
    holder_number: record[:holder_number].to_s.strip,
    holder_name: record[:holder_name].to_s.strip,
    address_line_1: record[:address_line_1].to_s.strip,
    address_line_2: record[:address_line_2].to_s.strip,
    address_line_3: record[:address_line_3].to_s.strip,
    address_line_4: record[:address_line_4].to_s.strip,
    address_line_5: record[:address_line_5].to_s.strip,
    postcode:  record[:postcode].to_s.strip.rjust(4, "0"), # NOTE: postcodes are treated as stings. This drops leading zeros. We need to pad them back to 4 digits as strings.
    esioa: (record[:esioa_09c] || record[:esioa]).to_i,
    esiob: (record[:esiob_015c] || record[:esiob]).to_i,
    phone_number: record[:phone_number].to_s.strip,
    work_number: record[:work_number].to_s.strip,
    mobile_number: record[:mobile_number].to_s.strip,
    email_address: record[:email_address].to_s.strip
  }
end

def csv_to_json(data)
  puts "... loading CSV records"
  csv = CSV.new(data, headers: true, header_converters: :symbol, converters: :all)
  csv.to_a.map {|row|
    row.to_hash
  }
end

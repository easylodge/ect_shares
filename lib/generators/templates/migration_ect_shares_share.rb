class CreateVedaCreditCommercialRequest < ActiveRecord::Migration
  def self.up
    unless ActiveRecord::Base.connection.table_exists? 'ect_shares_share'
      create_table :ect_shares_share do |t|
        t.string :holder_number
        t.string :holder_name
        t.string :address_line_1
        t.string :address_line_2
        t.string :address_line_3
        t.string :address_line_4
        t.string :address_line_5
        t.string :postcode
        t.integer :esioa
        t.integer :esiob
        t.string :phone_number
        t.string :work_number
        t.string :mobile_number
        t.string :email_address
        t.timestamps
      end
    end
  end

  def self.down
    drop_table :ect_shares_share if ActiveRecord::Base.connection.table_exists? 'ect_shares_share'
  end
end

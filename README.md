# ECT Shares

Ruby gem to make requests to ECT share service.

## Installation

Add this line to your application's Gemfile:

    gem 'ect_shares'

And then execute:

    $ bundle

Then run install generator:

	rails g ect_shares:install

Then run migrations:

	rake db:migrate


## Usage

### Ect::Share

    share = Ect::Share.find(shareholder_number, postcode)

#### Instance Methods:

  holder_number -
  holder_name -
  address_line_1 -
  address_line_2 -
  address_line_3 -
  address_line_4 -
  address_line_5 -
  postcode -
  esioa - number of shares availble
  esiob - number of shares availble
  phone_number -
  work_number -
  mobile_number -
  email_address -

### Ect::Calc

    calc = Ect::Calculate.find(share, count)

#### Instance Methods:
  buy_options - how many shares are being purchased
  max_options - maximum number of shares available for purchase
  unit_price - price per share (esioa = 9c, esiob = 1.5c)
  strike_price - unit_price * buy_options
  deposit - cash deposit on purchase
  purchase_price - strike_price - deposit
  lsr - ratio of purchase_price_mount / strike_price_amount
  payment_plan - 6 months advance; 12 months advance; 6 months arrears
  interest_rate - derived from lookup table
  term - always 36 months


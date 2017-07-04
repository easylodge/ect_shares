class EctShares::Calculator

  PAYMENT_METHODS = ['6 months arrears', '6 months advance', '12 months advance', 'default']

  INTEREST_TABLE = {
    # 55, 75 etc at "up to and inclusive
    '55': {
      '6 months advance':  4.13,
      '12 months advance': 3.13,
      '6 months arrears':  5.13,
      'default':           10.13
    },
    '75': {
      '6 months advance':  6.63,
      '12 months advance': 5.63,
      '6 months arrears':  7.63,
      'default':           11.63
    },
    '85': {
      '6 months advance':  7.63,
      '12 months advance': 6.63,
      '6 months arrears':  8.63,
      'default':           12.13
    },
    '100': {
      '6 months advance':  9.63,
      '12 months advance': 8.63,
      '6 months arrears':  11.63,
      'default':           14.63
    }
  }

  attr_accessor :count
  attr_accessor :share
  attr_accessor :deposit
  attr_accessor :payment_method

  def initialize(share)
    @share = share
    @deposit = 0
    @count = 0
    @payment_method = nil
  end

  def strike_price
    unit_price * [count, share.available_units].min
  end

  def purchase_price
    [strike_price - deposit, 0].max
  end

  # NOTE: this return the ratio of how much money we need to borrow, vs how much the shares actualy cost
  # always between 0 and 1
  def lsr
    # NOTE: force type coersion to decimal
    [1.0*purchase_price / strike_price, 1].min
  rescue
    1.0
  end

  def rate
    return unless PAYMENT_METHODS.include?(payment_method)

    INTEREST_TABLE.sort{|a, b| a.first.to_s.to_i <=> b.first.to_s.to_i}.each do |lsr_cap, rates|
      lsr_cap = lsr_cap.to_s.to_f/100.0
      if lsr_cap >= lsr
        return rates[payment_method.to_sym]
      end
    end
  end

  def advance?
    @payment_method.include?('advance')
  end

  def arrears?
    @payment_method.include?('arrears')
  end

  def unit_price
    case share.kind
    when EctShares::Share::ESIOA
      0.9
    when EctShares::Share::ESIOB
      1.5
    else
      0.0
    end
  end
end

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
    max_units = [self.count, self.share.available_units].min
    share.unit_price * max_units
  end

  def purchase_price
    strike_price - self.deposit
  end

  def lsr
    1.0*purchase_price / strike_price
  end

  def get_rate
    return unless PAYMENT_METHODS.include?(self.payment_method)

    INTEREST_TABLE.sort{|a, b| a.first.to_s.to_i <=> b.first.to_s.to_i}.each do |lsr_cap_str, rates|
      lsr_cap = lsr_cap_str.to_s.to_f
      if lsr_cap >= self.lsr
        return rates[self.payment_method.to_sym]
      end
    end
  end
end

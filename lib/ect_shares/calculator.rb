class EctShares::Calculator

  PAYMENT_METHODS = ['6 months arrears', '6 months advance', '12 months advance', 'default']

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

  def advance?
    @payment_method.include?('advance')
  end

  def arrears?
    @payment_method.include?('arrears')
  end

  def unit_price
    case share.kind
    when EctShares::Share::ESIOA
      0.9/100.0 # 0.9 cents
    when EctShares::Share::ESIOB
      1.5/100.0 # 1.5 cents
    else
      0.0
    end
  end
end

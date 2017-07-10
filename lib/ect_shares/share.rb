class EctShares::Share < ActiveRecord::Base
  self.table_name = "ect_shares_share"

  SHARE_KINDS = ['ESIOA', 'ESIOB'].sort

  validates :holder_number, presence: true
  validates :postcode, presence: true

  def esioa?
    esioa.to_i > 0
  end

  def esiob?
    esiob.to_i > 0
  end

  def available_units(kind=nil)
    case kind
    when 'ESIOA'
      esioa.to_i
    when 'ESIOB'
      esiob.to_i
    else
      0
    end
  end

end

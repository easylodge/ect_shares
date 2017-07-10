class EctShares::Share < ActiveRecord::Base
  self.table_name = "ect_shares_share"

  SHARE_TYPES = ['ESIOA', 'ESIOB'].sort

  validates :holder_number, presence: true
  validates :postcode, presence: true

  def esioa?
    esioa.to_i > 0
  end

  def esiob?
    esiob.to_i > 0
  end

  def available_units(share_type=nil)
    p "available_units(#{share_type})  : #{esioa.to_i}, #{esiob.to_i}"
    case share_type
    when 'ESIOA'
      esioa.to_i
    when 'ESIOB'
      esiob.to_i
    else
      0
    end
  end

end

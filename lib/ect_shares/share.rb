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

  def address
    lines = [address_line_1, address_line_2, address_line_3, address_line_4, address_line_5]
    lines.reject!{|x| x.blank?}
    lines.join(", ")
  end
end

class EctShares::Share < ActiveRecord::Base
  self.table_name = "ect_shares_share"

  ESIOA = 'ESIOA'
  ESIOB = 'ESIOB'

  def kind
    if esioa > 0
      ESIOA
    elsif esiob > 0
      ESIOB
    else
      nil
    end
  end

  def available_units
    [esioa.to_i, esiob.to_i].compact.detect{|x| x > 0} || 0
  end

end

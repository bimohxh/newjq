class Checkin < ActiveRecord::Base
  belongs_to :mem

  def isrow
    [Date.yesterday,Date.today].include? enddt
  end

  def continues
    if isrow
      (enddt - begdt).to_i + 1
    else
      0
    end
  end
end

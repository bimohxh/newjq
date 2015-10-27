class MemInfo < ActiveRecord::Base
  belongs_to :mem


  def city_alia
    city.blank? ? '外星人' : city
  end

end

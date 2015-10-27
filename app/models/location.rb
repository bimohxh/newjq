class Location < ActiveRecord::Base
  @location_key="LOCATION"

  def self.locations
    Rails.cache.write(@location_key, Location.select('cd','code','parent','nm','nmen').order('cd asc')) if Rails.cache.read(@location_key).nil? 
    Rails.cache.read(@location_key)
  end

  def self.bycd cd 
    self.locations.find_all{|r|r.cd == cd.to_i}[0]
  end
end

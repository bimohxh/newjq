class Refcd < ActiveRecord::Base
  @@CACHE_KEY="REFCD"

  def self.current(cd)
    Rails.cache.write(@@CACHE_KEY, Refcd.order('id asc')) if Rails.cache.read(@@CACHE_KEY).nil?
    Rails.cache.read(@@CACHE_KEY).find_all{|r|r.cd == cd}
  end

  def self.key(cd,key)
    Rails.cache.write(@@CACHE_KEY, Refcd.order('id asc')) if Rails.cache.read(@@CACHE_KEY).nil?
    Rails.cache.read(@@CACHE_KEY).find_all{|r|r.cd == cd && r.key == key}
  end

end

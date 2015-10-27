class Favorite < ActiveRecord::Base
  belongs_to :mem
  def self.collect?(typ,idcd,mem)
    return Favorite.where({:typ=>typ,:idcd=>idcd,:mem_id=>mem.id}).count > 0
  end
  
end

class Admin::CacheController < ApplicationController
  def all
    _typ = params[:typ]
    if _typ == 'all'
      expire_all
    else
      expire_typ_all _typ
    end
    redirect_to request.referer
  end
  def plugin
    
  end
  def video
    
  end
  def code
    
  end
  def sitemap
    
  end
end

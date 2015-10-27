class FollowController < ApplicationController
  before_filter :follow_filter,:is_mem_login? 

  def update
    respond_to do |format|
      format.html
      format.json { 
        _para = {:from_id=>current_mem.id,:to_id=>@to_mem.id}
        _follow = Follow.where(_para)[0]
        _flag = false
        if _follow
          _follow.destroy
        else
          Follow.create(_para) 
          _flag = true
        end
        current_mem.upload_following
        Mem.find(params[:to]).upload_follower
        ActiveSupport::Notifications.instrument 'follow.create',:tomem=> @to_mem,:nc=> current_mem.nc if _flag
        render json: {
          :isfollow=> !Follow.where({:from_id=>current_mem.id,:to_id=>@to_mem.id})[0].nil?
        }
      }
    end
  end

  def isfollow
    respond_to do |format|
      format.html
      format.json {
        render json: {
          :isfollow=> !Follow.where({:from_id=>current_mem.id,:to_id=>@to_mem.id})[0].nil?
        }
      }
    end
  end

end

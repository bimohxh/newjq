class FavorController < ApplicationController 
	before_filter :is_mem_login?
	def destroy
    _item = current_mem.favorites.where({:idcd=>params[:idcd],:typ=>params[:typ]}).first
    render json:{status: false} and return  if !_item
    _item.destroy
    render json:{status: true}
  end
end

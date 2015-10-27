class CommentController < ApplicationController
  before_filter :is_mem_login?,:only=> ['create','destroy']

  def create
    _item = Comment.create({:typ=> params[:typ],:idcd=>params[:id],:con=>params[:con],:mem_id=>current_mem.id})
    _item.update_num
    ActiveSupport::Notifications.instrument 'comment.create',:idcd=> params[:id],:typ=> params[:typ],:item=> _item if _item.target.mem_id != current_mem.id
    render json: {
      status: true
    }
  end

  def list
    _items = Comment.where(:typ=>params[:typ],:idcd=>params[:idcd])
    render json:{
      :items=> data_list_asc(_items),
      :count=> _items.count
    }.to_json(:methods=>['friendly_time','raw_con'],:include=>{:mem=>{:only=>['photo','nc']}})
  end

  def destroy
    _item = Comment.find(params[:id])
    render json: {status: false} and return if !_item.isme?(current_mem)
    _item.destroy
    _item.update_num
    render json: {status: true} 
  end

  def index
    redirect_to Comment.find(params[:id]).link
  end

end

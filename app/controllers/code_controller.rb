class CodeController < ApplicationController
  before_filter(except: ['new','save']){|c| c.lost_item Code}
  before_filter :is_mem_login?,:only=>['save','update','destroy']

  def index  
    respond_to do |format|
      format.html{
        @comment = {:id=>@item.id,:typ=>'code'} if @item 
      }
      format.json { 
        @item = current_mem.codes.create({}) if !@item
        render json: {
          :item=> @item,
          :ismy=> (current_mem and @item.mem == current_mem),
          :isfavor=> (current_mem and Favorite.collect?('code', @item.id,current_mem)),
        }.to_json(:include=>{:mem=>{:only=>['photo','nc']}})
      }
    end
  end
  
  def new
    render "index"
  end
  

  def save 
    #params[:code][:keywords] = params[:code][:keywords].join(',')
    _item = current_mem.codes.create({:title=>params[:title],:shtml=> params[:shtml],:scss=>params[:scss],:sjs=>params[:sjs]})
    #redirect_to '/mem/tip',:notice=> t('pubedok')
    render json:{status: true,id: _item.id}
  end 

  def update
    _item = @item.update_attributes({:shtml=> params[:shtml],:scss=>params[:scss],:sjs=>params[:sjs]})
    render json:{status: true}
  end

  def destroy
    render json:{status: false} and return if @item.mem != current_mem
    @item.destroy
    render json:{status: true}
  end

  def fork
    _item = @item.dup
    _item.title = params[:title]
    _item.mem_id = current_mem.id
    _item.visit = 0
    _item.collect = 0
    _item.comment = 0
    _item.save
    render json:{status: true,id: _item.id}
  end


  def comments
    _items = Comment.where(:typ=>'code',:idcd=>@item.id)
    render json:{
      :items=> data_list_asc(_items),
      :count=> _items.count
    }.to_json(:methods=>['friendly_time'],:include=>{:mem=>{:only=>['photo','nc']}})
  end
end

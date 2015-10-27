class VideoController < ApplicationController
  before_filter(except: ['new','save']){|c| c.lost_item Video}

  def index
    @src = qiniu_down(@item.src_url,3600)
    @comment ={:id=>@item.id,:typ=>'video'} 
  end

  def new
    @item = Video.new
    @item.keywords = ''
    @path = '/video/save'
  end

  def comments
    _items = Comment.where(:typ=>'video',:idcd=>@item.id)
    render json:{
      :items=> data_list_asc(_items),
      :count=> _items.count
    }.to_json(:methods=>['friendly_time'],:include=>{:mem=>{:only=>['photo','nc']}})
  end

  def save 
    current_mem.videos.create(params.require(:video).permit(Video.attribute_names))
    redirect_to '/mem/tip',:notice=> t('pubedok')
  rescue
    redirect_to '/mem/tip',:notice=> t('pubedfail')
  end 

end

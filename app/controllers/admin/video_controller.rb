class Admin::VideoController < AdminController
  before_filter :video_lost
  def destroy
    ActiveSupport::Notifications.instrument 'source.destroy',:item=> @item,:reason=> params[:reason]
    @item.destroy
    render  json: {status: true}
  end

  def reset
    if @item.recsts == '0'
      @item.recsts = '1' 
    else
      @item.recsts = '0' 
    end
    @item.save
    render text: @item.recsts
  end

  def check
    @item.recsts = '0'
    @item.save 
    FundRecord.author_get(@item,params[:award].to_i)
    ActiveSupport::Notifications.instrument 'source.check',:item=> @item,:url=> "/video/#{@item.id}"
    render text: @item.recsts
  end 

  def edit
    @item = Video.find(params[:id])
    @item.keywords = '' if !@item.keywords
    @path = "/admin/video/update"
  end

  def update
    _keywords = params[:video][:keywords]
    params[:video][:keywords] = _keywords.join(',') if _keywords
    _item = Video.find(params[:video][:id])
    _item.update_attributes(params.require(:video).permit(Video.attribute_names))
    redirect_to request.referer
  end
  
end

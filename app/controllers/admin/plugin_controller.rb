class Admin::PluginController < AdminController
  before_filter :plugin_lost
  
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
    #ActiveSupport::Notifications.instrument 'source.check',:item=> @item,:url=> "/plugin/#{@item.id}"
    render text: @item.recsts
  end 

  def edit
    @path = "/admin/plugin/update"
  end

  def update
    params[:plugin][:keywords] = params[:plugin][:keywords].join(',')
    _item = Plugin.find(params[:plugin][:id])
    _item.update_attributes(params.require(:plugin).permit(Plugin.attribute_names))
    redirect_to request.referer
  end
  
end

class Admin::PluginconController < AdminController
  before_filter :plugincon_lost


  def destroy
    @item.destroy
    render json: {status: true}
  end

  def update
    @item.update_attributes({:con=>params[:con]}) 
    render json: {status: true}
  end

  def merge
    @item.plugin = '' if !@item.plugin
    @item.plugin.con << @item.con
    
    @item.plugin.save
    #expire_item 'plugin', @item.plugin.id
    FundRecord.plugincon_get(@item,params[:award].to_i)
    @item.recsts = 0
    @item.save
    render json: {status: true}
  end



end

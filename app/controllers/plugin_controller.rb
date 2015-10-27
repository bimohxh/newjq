class PluginController < ApplicationController
  before_filter(except: ['new','save']){|c| c.lost_item Plugin}
  before_filter :is_mem_login?,:only=>['new','save']
  before_filter :is_admin_login?,:only=>['edit','update']
  #caches_page :index, :demo

  def index
    redirect_to '/tip',:notice=> t('plugin_nocheck') if @item.recsts == '1' and !is_admin?
    @comment ={:id=>@item.id,:typ=>'plugin'}
  end

  def new
    @item = Plugin.new
    @item.keywords = ''
    @path = '/plugin/save'
  end

  def edit
    @path = '/plugin/update'
    render "new"
  end

  def demo
    render :layout => nil
  end

  def website
    redirect_to @item.website
  end

  def download
    if download_right?('plugin',@item.id)[:status]
      send_file Rails.application.config.down_dir + @item.download and return
      #send_file Rails.application.config.down_dir + "1.zip" and return
    end 
    _cost = @item.cost 
    render json: {status: false} and return  if _cost > current_mem.integral  
    FundRecord.plugin_give(@item,current_mem) if _cost > 0  

    @item.downnum += 1
    @item.save

    send_file Rails.application.config.down_dir + @item.download 
    #send_file Rails.application.config.down_dir + "1.zip"
  end

  def save 
    current_mem.plugins.create(params.require(:plugin).permit(Plugin.attribute_names))
    redirect_to '/mem/tip',:notice=> t('pubedok')
  #rescue
  #  redirect_to '/mem/tip',:notice=> t('pubedfail')
  end 

  def update
    @item.update_attributes(params.require(:plugin).permit(Plugin.attribute_names))
    redirect_to request.referer
  end

  def con
    @item.plugincons.create({:mem_id=>current_mem.id,:con=>params[:con]})
    render json: {status: true}
  rescue
    render json: {status: false}
  end

  def bug
    _where = {:typ=>'BUG',:key=>params[:pid],:sdesc=>params[:sdesc],:fdesc=>params[:fdesc]}
    Doc.create(_where) if Doc.where(_where)[0].nil?
    render json: {status: true}
  rescue
    render json: {status: false}  
  end

  def collect_follow
    render json: {
      isfollow: !Follow.where({:from_id=>current_mem.id,:to_id=>@item.mem.id})[0].nil?,
      isfavor: Favorite.collect?('plugin', @item.id,current_mem)
    } 
  end

  def visitinc
    @item.update_column('visit',@item.visit + 1)
    render json: true
  end
end

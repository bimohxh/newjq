class AdminController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  #protect_from_forgery with: :exception
  before_filter :is_admin?

  def is_admin? 
    redirect_to "/" and return  if !session[:mem] || !(session[:admin] || Mem.find_by_id(session[:mem]).admin)
  end

  def max_page_size
    100
  end
    
  def default_page_size
    15
  end

  def page_size
    size = params[:pagesize].to_i
    [size.zero? ? default_page_size : size, max_page_size].min
  end

  def page
    @page = params[:page]
    @page = 1 if !@page
    @page =  @page.to_i - 1
  end

  def data_list query
    query.order('id desc').limit(page_size).offset(page * page_size)
  end

  def data_list_asc query
    query.order('id asc').limit(page_size).offset(page * page_size)
  end


  def adminlists items,permits,jsonextra={}
    respond_to do |format|
      format.html
      format.json { 
        _items = items
        if params[:para] and params[:para] != {}
          _items = _items.where(params.require(:para).permit(permits))
        end
        render json: {
          items: data_list(_items),
          count: _items.count
        }.to_json(jsonextra)
      }
    end
  end
  
  #根据参数获取模型
  def model(typ)
    video = ->(id) do 
      Video
    end
    plugin = ->(id) do 
      Plugin
    end
    code = ->(id) do 
      Code
    end
    binding.eval(typ).call(nil)
  end
  

  def plugin_lost
    @item = Plugin.where({:id=>params[:id]})[0] 
  end

  def code_lost
    @item = Code.where({:id=>params[:id]})[0]  
  end

  def video_lost
    @item = Video.where({:id=>params[:id]})[0]  
  end

  def plugincon_lost
    @item = Plugincon.where({:id=>params[:id]})[0]  
  end

  #过滤上传文件
  def test_file
    _typs = []
    _size = 0
    if params[:action] == 'pluginzip'
      _typs = ['zip','rar']
      _size = 15
    end
    if params[:action] == 'thumbnail'
      _typs = ['jpg','jpeg','gif','png']
      _size = 5
    end
    if params[:action] == 'demo'
      _typs = ['zip']
      _size = 40
    end
    _file = params[:filedata]
    _suffix = _file.original_filename.split('.').last 
    render json:{status: false,msg: t('filetyperror')} and return if !(_typs.include? _suffix.downcase)
    render json:{status: false,msg: t('filesizeerror')} and return  if _file.size > _size * 1024 * 1024
  end

  #解压 zip
  def unzip_file (file, destination)
    require 'zip/zip'
    Zip::ZipFile.open(file) { |zip_file|
      zip_file.each { |f|
       f_path=File.join(destination, f.name)
       FileUtils.mkdir_p(File.dirname(f_path))
       zip_file.extract(f, f_path) unless File.exist?(f_path)
      }
    }
  end 

  #存储文件到七牛
  def upload_qiniu(file,filename) 
    put_policy = Qiniu::Auth::PutPolicy.new('jqcon') 
    token = Qiniu::Auth.generate_uptoken(put_policy)
      
    para = {
      :key => filename,
      :token => token,  
      :file => file
    }
    require 'rest_client'
    response = RestClient.post(Rails.application.config.qiniu_upload, para)
    filename
  end
   

  
  def my_encrypt(str)
    key = Rails.application.config.encrypt_key
    data = FastAES.new(key).encrypt(str)
  end
  
  def my_decrypt(str)
    key = Rails.application.config.encrypt_key
    FastAES.new(key).decrypt(str)
  end


  #清空页面缓存
  def remove_dir folder
    require 'fileutils'
    FileUtils.rm_r  "#{Rails.root}/public/cache/#{folder}", :force => true 
  end

  def remove_file file
    require 'fileutils'
    FileUtils.rm "#{Rails.root}/public/cache/#{file}", :force => true 
  end

  #详情页面过期
  def expire_item(typ,id)
    if typ == 'code'
      expire_page(:controller => 'code', :action => 'detail',:id => id) 
      expire_page(:controller => 'code', :action => 'preview',:id => id) 
    end
    expire_page(:controller => 'video', :action => 'detail',:id => id) if typ == 'video'
    if typ == 'plugin'
      remove_file "jquery-info#{id.to_s}.html"
      remove_file "Demo#{id.to_s}.html"
    end 
  end

  #列表页过期
  def expire_list typ
    if typ == 'video'
      remove_dir "video/home" 
      remove_file "video/home.html"
    end
    if typ == 'code'
      remove_dir "code/home" 
      remove_file "code/home.html"
    end
    if typ == 'plugin'
      remove_dir "jquery"
      remove_file "index.html" 
    end
    if typ == 'sitemap'
      remove_file "sitemap.xml"
    end
  end

  #整个类型过期
  def expire_typ_all typ
    remove_dir typ
    expire_list typ
    if typ == 'plugin'
      Plugin.all.each{|item|
        expire_item(typ,item.id)
      }
    end
  end

  #所有页面过期
  def expire_all
    remove_dir ''
  end


  def logout
    session[:admin] = nil
    redirect_to "/"
  end


end

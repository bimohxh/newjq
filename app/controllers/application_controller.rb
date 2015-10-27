class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  #protect_from_forgery with: :exception
  before_filter :check_login,:has_info?
 

  def not_found
    raise ActionController::RoutingError.new('Not Found') and return 
  end

  def is_mem_login?
    redirect_to '/tip',:notice=> t('no_login') and return  if !is_login?
  end

  def check_login
    @is_login = is_login?
  end

  def has_info?
    redirect_to '/mem/info' and return if current_mem and (current_mem.nc.blank? or current_mem.email.blank?)
  end

  def is_login?
    if session[:mem].nil?
      return false if !cookies[:autologin]
      _val = my_decrypt(cookies[:autologin]).split('-')
      _id = _val[0]
      _mem = Mem.find_by_id(_id)
      return false if _mem.nil? or _mem.created_at.to_i != _val[1].to_i #or (Time.now.to_i - _val[2].to_i) / (60*60*24) > 30
      session[:mem] = _mem.id
    end
    true
  end

  def is_admin?
    session[:admin] || Mem.find_by_id(session[:mem]).admin
  end

  def is_admin_login?
    redirect_to '/tip',:notice=> t('no_admin_login') and return  if !is_admin?
  end
  
  def is_me?
    #session[:mem] = 1
    _id = params[:id].to_i 
    if _id > 0
      @mem = Mem.where({:id=>params[:id]})[0]
      redirect_to '/tip',:notice=> t('mem_none') and return if !@mem 
    else
      redirect_to '/tip',:notice=> t('no_login') and return  if session[:mem].to_i < 1
      @mem = current_mem
    end
    redirect_to '/tip',:notice=> t('mem_novalid') and return if @mem.recsts == '1'
    @isme = (@mem == current_mem)
  end

  def current_mem 
    Mem.find_by_id(session[:mem])
  end

  def follow_filter
    @to_mem = Mem.find(params[:to].to_i)
    render  json:{status: false} and return if !@to_mem or @to_mem == current_mem
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

  def data_list query,pagesize=page_size
    query.order('id desc').limit(pagesize).offset(page * pagesize)
  end

  def data_list_asc query
    query.order('id asc').limit(page_size).offset(page * page_size)
  end

  def mem_layout
    render :layout=>'mem'
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
    ask = ->(id) do 
      Ask
    end
    answer = ->(id) do 
      Answer
    end
    binding.eval(typ).call(nil)
  end
  
  def lost_item model
    not_found if !(@item = model.find_by_id params[:id])
  end

  def ask_edit?
    redirect_to '/tip',:notice=> '你无权进行此操作' and return if (!is_admin? and current_mem != @item.mem)
  end

  #过滤上传文件
  def test_file
    _typs = []
    _size = 0
    if params[:action] == 'pluginzip'
      _typs = ['zip','rar']
      _size = 15
    end
    if params[:action] == 'pic'
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
  
  #七牛私有空间访问
  def qiniu_down url,expires_in
    put_policy = Qiniu::Auth::PutPolicy.new('jqcon') 
    Qiniu::Auth.authorize_download_url(url,{:expires_in =>expires_in}) 
  end
   
  def download_right? typ,idcd
    return {:status =>false} if !current_mem 
    
    _item = (typ == 'plugin' ? Plugin.find(idcd) : Video.find(idcd)) 

    return {:status=>true,:msg=>t('allowdown0')} if session[:mem] ==  _item.mem.id

    return {:status=>true,:msg=>t('allowdown1')} if is_admin?

    return {:status=> true,:msg=>t('allowdown2')} if !current_mem.buylogs.where({:typ=>typ,:idcd=>idcd})[0].nil?
    
    return {:status=> false,:nomoney=> true} if _item.cost > current_mem.integral
    
    return {:status =>false}
  end
  
  def my_encrypt(str)
    key = Rails.application.config.encrypt_key
    data = FastAES.new(key).encrypt(str)
  end
  
  def my_decrypt(str)
    key = Rails.application.config.encrypt_key
    FastAES.new(key).decrypt(str)
  end

  def sub_directories path
    Dir.chdir path
    Dir["*"].reject{|o| not File.directory?(o)}
  end

  def sub_files path
    Dir.chdir path
    Dir.glob("*.*")
  end

  def cache(key, expires_in=5.minute, &get_val_block)
    _cache = Rails.cache
    _key = key.to_sym
    _val = _cache.fetch(_key)
    if _val.nil?
      _val = get_val_block.call
      _cache.write(_key, _val, expires_in: expires_in)
    end
    _val
  end

  def upload_file(file,filename,folder,width,height)
    _full_path = "#{Rails.root}/public/upload/#{folder}/#{filename}"
    image = MiniMagick::Image.read(file)
    if width.to_i > 0 and height.to_i > 0
      _width = image[:width]
      _height = image[:height]
      _x = 0
      _y = 0
      if width / height > _width / _height
        image.resize "#{width}x"
        _y = ((image[:height] - height) / 3.0 * 2).to_i
      else
        image.resize "x#{height}"
        _x = ((image[:width] - width) / 2.0).to_i
      end
      image.crop "#{width}x#{height}+#{_x}+#{_y}"
    end
    image.write  _full_path
    FileUtils.chmod 0755, _full_path
    return _full_path
  end

  def aliyun_upload file,target
    _connection = CarrierWave::Storage::Aliyun::Connection.new({
      :aliyun_access_id=> Rails.application.config.aliyun_access_id,
      :aliyun_access_key=> Rails.application.config.aliyun_access_key,
      :aliyun_bucket=> Rails.application.config.aliyun_bucket,
      :aliyun_area=> Rails.application.config.aliyun_area,
      :aliyun_upload_host=> Rails.application.config.aliyun_upload_host
    })
    _connection.put(target, file)
  end

  #存储远程文件到本地
  def upload_remote(remote_src,filename,dir)
    require 'open-uri' 
    web_contents  = open(remote_src).read
    aliyun_upload web_contents,"#{dir}/#{filename}"
  end

  def clear_fragment key
    ActionController::Base.new.expire_fragment(key)
  end

end

module ApplicationHelper
  def current_mem 
    Mem.find_by_id(session[:mem])
  end
  
  def is_admin?
    session[:admin] || Mem.find_by_id(session[:mem]).admin
  end

  def access_path folder
    Rails.application.config.source_access_path + folder + "/"
  end

  def my_cache(key, expires_in=5.minute, &get_val_block)
    _cache = Rails.cache
    _key = key.to_sym
    _val = _cache.fetch(_key)
    if _val.nil?
      _val = get_val_block.call
      _cache.write(_key, _val, expires_in: expires_in)
    end
    _val
  end

  def sub_directories path
    Dir.chdir path
    Dir["*"].reject{|o| not File.directory?(o)}
  end

  def sub_files path
    Dir.chdir path
    Dir.glob("*.*")
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
    @page.to_i - 1
  end

  def data_list query,pagesize=page_size
    query.order('id desc').limit(pagesize).offset(page * pagesize)
  end

  def data_list_asc query
    query.order('id asc').limit(page_size).offset(page * page_size)
  end

  def comments typ,idcd
    _items = Comment.includes(:mem).where(:typ=>typ,:idcd=>idcd)
    {
      :items=> data_list_asc(_items),
      :count=> _items.count
    }
  end

  
end

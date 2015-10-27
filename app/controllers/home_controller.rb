class HomeController < ApplicationController

  def videos
    @items = data_list(Video.where({:recsts => '0'})).includes(:mem)
    @count = Video.where({:recsts => '0'}).count
  end


  def tip
  end

  def help    
  end

  def pwd
    respond_to do |format|
      format.html
      format.json {
        redirect_to '/tip',:notice=> '你已经发送过邮件，请勿重复发送！'  and return if Pwdkey.find_by_email(params[:email])
        _key = UUIDTools::UUID.random_create
        _url = Rails.application.config.base_url + "setpwd/#{_key}"
        Pwdkey.create({:email=>params[:email], :key=>_key})
        AdminMailer.findpwd({:receiver=>params[:email],:url=>_url}).deliver
        redirect_to '/tip',:notice=> t('send_pwd') and return
      }
    end
  end

  def setpwd
    @item = Pwdkey.where({:key=>params[:search]})[0]
    redirect_to '/tip',:notice=> t('no_valide_pwd_link') and return if !@item 
  end

  def verfiy
    
  end

  def about
    
  end

  #是否收藏
  def isfavor
    render json: false and return if current_mem.nil?
    render json: {
        isfavor: Favorite.collect?(params[:typ], params[:idcd].to_i,current_mem)
    } 
  end

  #收藏
  def collect
    _typ = params[:typ]
    _idcd = params[:idcd].to_i
    _where = {:idcd=>_idcd,:typ=>_typ,:mem_id=>current_mem.id}

    if Favorite.collect?(_typ,_idcd,current_mem)
      current_mem.favorites.destroy(Favorite.where(_where))
    else 
      current_mem.favorites.create(:idcd=>_idcd,:typ=>_typ)
    end
    
    _total = Favorite.where({:idcd=>_idcd,:typ=>_typ}).count 
  
    _item = model(_typ).find(_idcd)
    _item.collect  = _total
    _item.save!
  
    render json: {
      isfavor: Favorite.collect?(_typ,_idcd,current_mem)
    }
  end


  def auth
    _data = request.env["omniauth.auth"] 
    #render json: _data and return

    _provider = params[:provider]
    _para = {
      :provider => _provider,
      :uid => _data['uid']
    }
    _mauth = Mauth.where(_para).first
    
    #注册 /  绑定账号
    if _mauth.nil?
      _mem = current_mem
      if !_mem
        _photo = ''
        if _provider == 'qq_connect'
          _photo = _data['extra']['raw_info']['figureurl_qq_2']
        end
        if _provider == 'weibo'
          _photo = _data['extra']['raw_info']['avatar_hd']
        end
        if _provider == 'github'
          _photo = _data['extra']['raw_info']['avatar_url']
        end

        require 'uuidtools'   
        _filename =  UUIDTools::UUID.timestamp_create.to_s + '.jpg'
        upload_remote(_photo,_filename,'mem') 
        _mem = Mem.create({
          :nc => _data['info']['nickname'],
          :gender => deal_gender(_data['extra']['gender']),
          :photo => _filename
        })
      end
      _mem.mauths.create(_para)
      session[:mem] = _mem.id
      
    else 
      session[:mem] = _mauth.mem.id
    end
    render :layout=>nil
  end

  

  #def locations
  #  render json: {
  #    :items=> Location.locations
  #  }
  #end

  def sitemap
    require 'uri'
    _plugins = Plugin.where({:recsts=> 0}).order('id desc').all.map do |item|
      {
        :loc => Rails.application.config.base_url + "plugin/#{item.id}",
        :lastmod => item.updated_at,
        :changefreq => 'daily',
        :title =>item.title,
        :tag => item.keywords ? item.keywords.split(',') : '',
        :pubTime => item.created_at,
        :breadCrumb =>[
          {:title=>item.root_typ,:url=>Rails.application.config.base_url + URI.encode("?rtyp=#{item.root_typ}")},
          {:title=>item.typ,:url=>Rails.application.config.base_url + URI.encode("?typ=#{item.typ}")}
        ],
        :thumbnail =>item.pic,
      }
    end
    _codes = Code.where({:recsts=> 0}).order('id desc').all.map do |item|
      {
        :loc => Rails.application.config.base_url + "/code/#{item.id}",
        :lastmod => item.updated_at,
        :changefreq => 'daily',
        :title =>item.title,
        :tag => item.keywords ? item.keywords.split(',') : '',
        :pubTime => item.created_at,
      }
    end

    @items = _plugins + _codes

    respond_to do |format|
      format.html
      format.xml {render :layout =>nil }
    end
  end

  def rss
    @items = Plugin.where({:recsts => '0'}).order("id desc").limit(10).offset(0)
    respond_to do |format|
      format.html
      format.xml {render :layout =>nil }
    end
  end 

  
end

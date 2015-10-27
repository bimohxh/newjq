class MemController < ApplicationController
  before_filter :is_me?,:except=>['singup','login','cknc','ckemail','islogin','setpwd']
  skip_before_filter :has_info?
  
  def index 
    @alerts = data_list(@mem.unread_alerts)
  end

  def singup
    _mem = Mem.create({:email=> params[:semail],:nc=> params[:nc],:pwd=> Digest::MD5.hexdigest(params[:pwd]),:photo=>"m-#{rand(24) + 1}.jpg"})
    session[:mem] = _mem.id
    render json: {status: true} 
  rescue
    render json: {status: false,tip: t('singup_fail')}  
  end

  def login
    _mem = Mem.where({:email=> params[:lemail],:pwd=> Digest::MD5.hexdigest(params[:pwd])})[0]
    render json: {status: false,tip: t('login_fail')} and return if !_mem
    render json: {status: false,tip: t('mem_novalid')} and return if _mem.recsts == '1'

    session[:mem] = _mem.id
    #if params[:remember] == 'on'
      #cookies[:autologin] = { :value => my_encrypt(_mem.id.to_s + "-" + _mem.created_at.to_i.to_s + '-' + Time.now.to_i.to_s), :expires => 30.day.from_now } 
    #end
    cookies[:autologin] = { :value => my_encrypt(_mem.id.to_s + "-" + _mem.created_at.to_i.to_s),:expires => 30.day.from_now } 
    render json: {status: true} 
  end

  def pwd
    
  end

  def setpwd
    _item = Pwdkey.where({:key=>params[:key]})[0]
    redirect_to '/tip',:notice=> t('setpwd_error_1') and return if !_item
    _mem = Mem.where({:email=>_item.email})[0]
    redirect_to '/tip',:notice=> t('setpwd_error_2') and return if !_mem
    _mem.pwd = Digest::MD5.hexdigest(params[:newpwd])
    _mem.save
    session[:mem] = _mem.id
    _item.destroy
    redirect_to '/tip',:notice=> t('setpwd_success')
  end

  def cknc
    _nc = params[:nc].blank? ? params[:mem][:nc] : params[:nc]
    render json: true and return if current_mem and current_mem.nc == _nc
    render json: Mem.find_by_nc(_nc).nil?
  end

  def ckemail
    _email = params[:semail].blank? ? params[:mem][:email] : params[:semail]
    render json: true and return if current_mem and current_mem.email == _email
    render json: Mem.find_by_email(_email).nil?
  end

  #是否登陆
  def islogin
    respond_to do |format|
      format.html
      format.json {
        if current_mem
          if current_mem.recsts == '1'
            session[:mem] = nil 
            render json: {status: false} and return
          end
          render json: {
            status: true,
            mem: current_mem.allow_show,
            missinfo: (current_mem.nc.to_s.strip == '' or current_mem.email.to_s.strip == ''),
            unread: current_mem.unread_alerts.count
          }
        else
          render json: {status: false}
        end
      }
    end
    
  end

  def logout
    session[:mem] = nil
    cookies[:autologin] = nil
    redirect_to request.referer
  end

  def followers
    respond_to do |format|
      format.html
      format.json {
        _items = data_list(@mem.fans_mems)
        
        if true
          _follows = @mem.fans_mems.pluck("id") 
          _items.each do |mem|
            mem.followstatus = _follows.include? mem.id
          end
        end

        render json:{
          items: _items,
          count: @mem.followers
        }.to_json(:methods=>['followstatus'])
      }
    end
  end

  def following
    respond_to do |format|
      format.html
      format.json {
        _items = data_list(@mem.follow_mems)
        
        if true
          _follows = @mem.follow_mems.pluck("id") 
          _items.each do |mem|
            mem.followstatus = _follows.include? mem.id
          end
        end

        render json:{
          items: _items,
          count: @mem.following
        }.to_json(:methods=>['followstatus'])
      }
    end
  end


  def favors
    respond_to do |format|
      format.html
      format.json {
        _typ = params[:search]
        _item_ids = data_list(@mem.favorites.where({:typ=>_typ})).pluck('idcd')
        _items = model(_typ).list_field.where({:id=> _item_ids})
        render json:{
          items: _items,
          count: @mem.favorites.where({:typ=>_typ}).count 
        }.to_json(:include=>{:mem=>{:only=>['photo','nc']}})
      }
    end
  end


  def pubeds
    respond_to do |format|
      format.html
      format.json {
        _typ = params[:search]
        _items = data_list(model(_typ).where({:mem_id=>@mem.id}))
        render json:{
          items: _items,
          count: model(_typ).where({:mem_id=>@mem.id}).count 
        }.to_json(:include=>{:mem=>{:only=>['photo','nc']}})
      }
    end		
  end 

  

  def recharge    
  end

  def orders
    respond_to do |format|
      format.html
      format.json {
        render json:{
          items: data_list(current_mem.orders),
          count: current_mem.orders.count
        }.to_json(:methods=>['state_alia']) 
      }
    end 
  end

  def record
    respond_to do |format|
      format.html
      format.json {
        render json:{
          items: data_list(current_mem.fund_records),
          count: current_mem.fund_records.count
        } 
      }
    end    
  end

  def nc
    _mem = Mem.where({:nc=>params[:search]})[0] 
    redirect_to "/mem/#{_mem.id}" and return if _mem
    redirect_to '/mem/msg',notice: t('mem_none')
  end

  def msg
    respond_to do |format|
      format.html
      format.json {
        _items = data_list(current_mem.alerts)
        ActiveSupport::Notifications.instrument 'mem.unread',:ids=> _items.map{|item| item.id} if _items.count > 0
        render json:{
          items: _items,
          count: current_mem.alerts.count
        } 
      }
    end
  end

  def unread
    respond_to do |format|
      format.html
      format.json {
        _items = data_list(current_mem.unread_alerts)
        ActiveSupport::Notifications.instrument 'mem.unread',:ids=> _items.map{|item| item.id} if _items.count > 0
        render json:{
          items: _items,
          count: current_mem.unread_alerts.count
        } 
      }
    end
  end

  def update
    current_mem.update params.require(:mem).permit(:nc,:email)
    current_mem.mem_info.update params.require(:mem_info).permit(:gender,:dob,:city)
    if !params[:pwd].blank?
      _pwd = Digest::MD5.hexdigest(params[:pwd])
      current_mem.update_attributes({:pwd=> _pwd})
    end
    render json: {status: true}
  end

  def avatar
    current_mem.update_attributes({:photo=> params[:photo]})
    render json: {status: true}
  end
  
  def tip    
  end

  def auths
    respond_to do |format|
      format.html
      format.json {
        render json:{
          items: current_mem.mauths.pluck('provider')
        } 
      }
    end
  end

  def balance
    render json: {integral: current_mem.integral,right: download_right?(params[:typ],params[:idcd].to_i)}
  end

  def ischeckin
    respond_to do |format|
      format.html
      format.json {
        render json: {
          ischeck: Checkin.where({:mem_id=>current_mem.id,:enddt=>Date.today}).count > 0,
          days: (_mycheckin = current_mem.checkin) ? _mycheckin.continues : 0  
        }   
      }
    end
  end

  def checkin
    respond_to do |format|
      format.html
      format.json {
        if (_mycheckin = current_mem.checkin) and _mycheckin.enddt == Date.yesterday
          _mycheckin.enddt = Date.today
          _mycheckin.save
          _days = (_mycheckin.enddt - _mycheckin.begdt).to_i + 1
          if _days >= 3
            FundRecord.checkin_get current_mem
          end
        else
          if _mycheckin 
            render json: {status: false} and return  if  _mycheckin.enddt == Date.today
            _mycheckin.destroy 
          end
          _mycheckin = Checkin.create({:mem_id=>current_mem.id,:begdt=> Date.today,:enddt=>Date.today})
        end
        render json: {
          ischeck: true,
          days:  (_mycheckin = current_mem.checkin) ? _mycheckin.continues : 0
        }
      }
    end
  end


  def avatar
    current_mem.update_attributes({:photo=> params[:photo]})
    render json: {status: true}
  end



end

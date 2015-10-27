class Admin::HomeController < AdminController
  def mems
    adminlists Mem,[:id,:email,:nc]
  end

  def orders
    adminlists Order,[:no,:mem_id],:include => {:mem => {:only=>[:nc,:id]}},:methods=>['state_alia']
  end

  def cards
    adminlists Card,[:key,:taobaouid,:mem_id],:include => {:mem => {:only=>[:nc,:id]}}
  end

  def records
    adminlists FundRecord,[:mem_id],:include => {:mem => {:only=>[:nc,:id]}}
  end

  def incomes
    _unit = params[:unit]
    _num = params[:num].to_i
    if _unit == 'month'
      _orders = Order.where("issend = '1' and date(created_at) > ?", Date.today.prev_month(_num)).select("year(created_at) as order_year,month(created_at) as order_month,count(id) as order_num,sum(price) as total").group("year(created_at),month(created_at)").map do |m|
        {
          :date=> "#{m.order_year}-#{m.order_month}" ,
          :money=> m.total,
          :num=> m.order_num
        }
      end 
    else
      _num = Date.today.day if _num == 0 
      _orders = Order.where("issend = '1' and  date(created_at) > ?", Date.today.prev_day(_num)).select("date(created_at) as order_date,count(id) as order_num,sum(price) as total").group("date(created_at)").map do |m|
        {
          :date=> m.order_date,
          :money=> m.total,
          :num=> m.order_num
        }
      end
    end
    render json: _orders
  end

  def comments
    adminlists Comment,[:mem_id,:idcd,:typ],{:methods=>['friendly_time'],:include => {:mem => {:only=>[:nc,:id]}}}
  end
  
  def searchs
    adminlists  Doc.where({:typ=>'SEARCH'}),[:key]
  end

  def bugs
    adminlists  Doc.where({:typ=>'BUG'}),[:key]
  end

  def feedbacks
    adminlists  Doc.where({:typ=>'SITEQ'}),[:key]
  end

  def plugins
    adminlists  Plugin,[],:include => {:mem => {:only=>[:nc,:id]}}
  end

  def codes
    adminlists  Code,[],:include => {:mem => {:only=>[:nc,:id]}}
  end

  def videos
    adminlists  Video,[],:include => {:mem => {:only=>[:nc,:id]}}
  end

  def plugincons
    adminlists  Plugincon,[],:include => [{:mem => {:only=>:nc}},{:plugin => {:only => [:title]}}]
  end

  def asks
    adminlists  Ask,[],:include => {:mem => {:only=>[:nc,:id]}}
  end
  def answers
    adminlists  Answer,[],:include => {:mem => {:only=>[:nc,:id]}}
  end
  def clearcache
    require 'fileutils'
    FileUtils.rm_r  "#{Rails.root}/tmp/cache", :force => true
    redirect_to request.referer
  end
end

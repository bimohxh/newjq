class PayController < ApplicationController
  def order 
    _orderno = DateTime.now.strftime('%Y%m%d%H%M%S') + current_mem.id.to_s
    options = {
      :out_trade_no      => _orderno, # 20130801000001
      :subject           => 'JQ币充值',   # Writings.io Base Account x 12
      :logistics_type    => 'DIRECT',
      :logistics_fee     => '0',
      :logistics_payment => 'SELLER_PAY',
      :price             => params[:price],
      :quantity          => 1,
      :discount          => '0',
      :return_url        => Rails.application.config.base_url + 'pay/callback', # https://writings.io/orders/20130801000001
      :notify_url        => Rails.application.config.base_url + 'pay/notify'  # https://writings.io/orders/20130801000001
    }
    current_mem.orders << Order.new({:no =>_orderno,:price=>params[:price],:remark=>'JQ币充值',:state=>'WAIT_BUYER_PAY'})
    redirect_to Alipay::Service.create_partner_trade_by_buyer_url(options)
  end

  def notify
    notify_params = params.except(*request.path_parameters.keys)
    if Alipay::Notify.verify?(notify_params)
      #File.open(Rails.root + 'test.txt', "a") do |f|
      #  f.write("\r\n====================\r\n" + params.to_s)
      #end

      _out_trade_no = params[:out_trade_no]
      _order = Order.where({:no =>_out_trade_no})[0]
      _order.update_attributes({:state =>params[:trade_status]})
      
      #交易状态
      case params[:trade_status]
        when 'WAIT_BUYER_PAY'
        when 'WAIT_SELLER_SEND_GOODS'
          
          options = {
            :trade_no       => params[:trade_no],
            :logistics_name => 'JQ22',
            :transport_type => 'DIRECT'
          }
          _result = Alipay::Service.send_goods_confirm_by_platform(options)
          if _order.issend == '0'
            FundRecord.recharge(Mem.find(_order.mem_id),Rails.application.config.payback.select{|m|m[:rmb].to_i == params[:total_fee].to_i}.first[:val].to_i)
            _order.update_attributes({:issend =>'1'})
          end  
        when 'TRADE_FINISHED'

        when 'TRADE_CLOSED'
      end 

      #退款状态
      if params[:refund_status] and params[:refund_status] != ''
         _order.update_attributes({:state =>params[:refund_status]})
        case params[:refund_status]
          when 'WAIT_SELLER_CONFIRM_GOODS'
            FundRecord.recharge(Mem.find(_order.mem_id),-Rails.application.config.payback.select{|m|m[:rmb].to_i == params[:total_fee].to_i}.first[:val].to_i)
          when 'REFUND_SUCCESS' 
        end
      end
      
      render text: 'success'
    else
      render text: 'fail'
    end 
  rescue
    render text: 'fail'
  end

  def callback
    redirect_to '/mem/recharge'
  end

  def card
    _card = Card.where({:key =>params[:key],:used=> "NOTUSED"})[0] 
    render json: {status: false} and return  if !_card
    
    _order = Order.create({:no => _card.taobaouid,:price=> _card.cost,:remark=>'充值卡充值',:state=>'TRADE_FINISHED',:mem_id=> current_mem.id,:issend =>'1'})
    FundRecord.card_recharge(current_mem,_card.val)
    _card.used = 'USED'
    _card.mem_id = current_mem.id
    _card.save
  
    render json: {status: true} and return 
  rescue  
    render json: {status: false} and return 
  end
end

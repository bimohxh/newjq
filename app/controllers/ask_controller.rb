class AskController < ApplicationController
  before_filter(except: ['new','save']){|c| c.lost_item Ask}
  before_filter :ask_edit?,:only=> ['edit','update']
  before_filter :is_mem_login?,:only=>['new','save']

  def index
    #@answers ={:id=>@item.id,:get=>'/code/comments',:typ=>'code'} 
    #@relates = Code.select("id,title").order('id desc').limit(9).offset(0) 
    @ismyask = (current_mem == @item.mem)
  end

  def new
    @item = Ask.new
    @item.keywords = ''
    @path = '/ask/save'
  end

  def edit
    @path = '/ask/update'
    render "new"
  end

  def save 
    redirect_to '/tip',:notice=> t('asknomoney') and return if params[:ask][:money].to_i > current_mem.integral
    _ask = current_mem.asks.create(params.require(:ask).permit(:title,:keywords,:con,:mem,:money))
    FundRecord.answer_give _ask
    redirect_to '/tip',:notice=> t('askok')
  rescue
    redirect_to '/tip',:notice=> t('askfail')
  end 

  def update
    @item.update_attributes(params.require(:ask).permit(:title,:keywords,:con))
    redirect_to request.referer
  end

  def answers
    _items = data_list_asc(@item.answers.where({:typcd=> "ANSWER"})).map do |an|
      [an,@item.answers.where({:typcd=> 'REPLY',:parent=> an.id})]
    end
    render json:{
      :items=> _items,
      :count=> _items.count
    }.to_json(:methods=>['friendly_time','raw_con'],:include=>{:mem=>{:only=>['photo','nc']}})
  end

  def visitinc
    @item.update_column('visit',@item.visit + 1)
    render json: true
  end

  def reward
    _num = params[:num].to_i
    if _num < 1 or _num > current_mem.integral
      redirect_to '/mem/tip',:notice=> t('rewardnomoney') and return 
    end
    @item.money += _num
    @item.save
    FundRecord.ask_reward_give @item,_num
    render json:{status: true}
  end
end

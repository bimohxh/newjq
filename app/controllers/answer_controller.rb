class AnswerController < ApplicationController
  def create
    _ask = Ask.find_by_id(params[:aid])
    _item = _ask.answers.create({:con=>params[:con],:mem_id=>current_mem.id,:parent=> params[:parent],:typcd=> (params[:parent].to_i == 0 ? 'ANSWER' : 'REPLY')})
    _ask.update_answer
    ActiveSupport::Notifications.instrument 'answer.create',:idcd=> params[:id],:typ=> params[:typ],:item=> _item if _ask.mem_id != current_mem.id
    render json: {status: true}
  end

  def vote
    _act = params[:act]
    render json: {status: false} and return if !['UP','DOWN'].include? _act
    _answer = Answer.find(params[:id])
    render json: {status: false,msg: t("vote1")} and return if _answer.mem_id == current_mem.id
    render json: {status: false,msg: t("vote2")} and return if _answer.vote_logs.where({:mem_id=> current_mem.id}).count > 0
    _answer.vote_logs.create({:act=> _act,:mem_id=> current_mem.id})
    _answer.update_vote
    render json: {status: true}
  end


  def adopt
    _ask = Ask.find(params[:aid])
    _answer = Answer.find(params[:id])
    render json:{status: false} and return if _ask.mem_id != current_mem.id
    render json:{status: false} and return if !(_ask.answers.include? _answer)
    
    #如果是第一次采纳加上对应的积分  
    FundRecord.answer_get(_ask) if _ask.status == 'UNSOLVE'

    _ask.adopt_cd = _answer.id
    _ask.status = 'SOLVED'
    _ask.save

    render json:{status: true}
  end

end

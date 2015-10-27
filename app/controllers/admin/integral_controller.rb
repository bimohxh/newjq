class Admin::IntegralController < AdminController
  def save
    _num = params[:num].to_i
    render json: {status: false, msg: '金额不能为0'} and return if _num == 0
    render json: {status: false, msg: '管理员密码错误'} and return if params[:pwd] != Rails.application.config.admin_pwd or _num == 0
    _mem = Mem.where({:id=>params[:mid]})[0]
    render json: {status: false, msg: '会员不存在'} and return if !_mem
    FundRecord.operate(_mem,_num,"手动操作："+ params[:remark])
    #redirect_to "/admin/record"
    render json: {status: true}
  end
end

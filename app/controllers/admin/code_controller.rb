class Admin::CodeController < AdminController
  before_filter :code_lost
  def destroy
    ActiveSupport::Notifications.instrument 'source.destroy',:item=> @item,:reason=> params[:reason]
    @item.destroy
    render  json: {status: true}
  end

  def reset
    if @item.recsts == '0'
      @item.recsts = '1' 
    else
      @item.recsts = '0' 
    end
    @item.save
    render text: @item.recsts
  end

  def check
    @item.recsts = '0'
    @item.save 
    FundRecord.author_get(@item,params[:award].to_i)
    ActiveSupport::Notifications.instrument 'source.check',:item=> @item,:url=> "/code/#{@item.id}"
    render text: @item.recsts
  end 

  def edit
    @item = Code.find(params[:id])
    @path = "/admin/code/update"
  end

  def update
    params[:code][:keywords] = params[:code][:keywords].join(',')
    _item = Code.find(params[:code][:id])
    _item.update_attributes(params.require(:code).permit(Code.attribute_names))
    redirect_to request.referer
  end
  
end

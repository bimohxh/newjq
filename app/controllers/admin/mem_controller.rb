class Admin::MemController < AdminController

  #封号
  def reset
    _item = Mem.find(params[:id])
    if _item.recsts == '0'
      _item.recsts = '1' 
    else
      _item.recsts = '0' 
    end
    _item.save
    render text: _item.recsts
  end

  def destroy
    Mem.find(params[:id]).destroy
    render  json: {state: true}
  end
end

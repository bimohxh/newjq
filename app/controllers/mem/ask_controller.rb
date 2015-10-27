class Mem::AskController < MemController
  before_filter :is_me? 

  def answers
    respond_to do |format|
      format.html
      format.json {
        _items = data_list(current_mem.answers)
        render json:{
          items: _items,
          count: current_mem.answers.count 
        }.to_json(:include=>{:ask=>{:only=>['title']}})
      }
    end   
  end
end

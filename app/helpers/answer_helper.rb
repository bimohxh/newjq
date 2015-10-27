module AnswerHelper
  def ismine
    current_mem and current_mem.id == @item.mem_id
  end
end

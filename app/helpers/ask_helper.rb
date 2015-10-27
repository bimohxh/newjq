module AskHelper
  def state_alia item
    item.status == 'UNSOLVE' ? "未解决" : "已解决"
  end
end

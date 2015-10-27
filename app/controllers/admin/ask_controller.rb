class Admin::AskController < AdminController
  def destroy
    Ask.find(params[:id]).destroy
    render  json: {state: true}
  end
end

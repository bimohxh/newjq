class Admin::BugController < AdminController
  def destroy
    Doc.find(params[:id]).destroy
    render  json: {state: true}
  end
end

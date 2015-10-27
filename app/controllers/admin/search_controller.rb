class Admin::SearchController < AdminController
  def destroy
    Doc.find(params[:id]).destroy
    render  json: {state: true}
  end
end

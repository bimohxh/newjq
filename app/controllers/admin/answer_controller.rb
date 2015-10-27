class Admin::AnswerController < AdminController
  def destroy
    Answer.find(params[:id]).destroy
    render  json: {state: true}
  end
end

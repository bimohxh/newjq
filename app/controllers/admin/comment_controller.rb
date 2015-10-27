class Admin::CommentController < ApplicationController

  def destroy
    Comment.find(params[:id]).destroy
    render  json: {state: true}
  end
end

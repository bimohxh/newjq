class DocController < ApplicationController
  #提交网站问题
  def feedback
    _doc = Doc.create(params.require(:doc).permit(Doc.attribute_names))
    AdminMailer.feedback(_doc).deliver
    redirect_to '/tip',:notice=> t('feedback')
  end
end

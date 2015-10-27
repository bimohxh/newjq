class Admin::CardController < ApplicationController
  def save
    _num = params[:num].to_i
    _num.times do |i|
      _arr = ['a','b','c','d','e','f','h','i','j','k','m','n','p','r','s','t','u','v','w','x','y','3','4','5','6','7']
      _key = _arr.sample(8).join('')
      _card = Card.create(params.require(:card).permit(Card.attribute_names))
      _card.key = _key
      _card.save
    end
    redirect_to request.referer
  end
end

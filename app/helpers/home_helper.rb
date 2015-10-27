module HomeHelper
  def tagurl para
    _paras = ['tag','filter','rtyp','typ'].select{|m| !para[m.to_sym].blank?}
    if _paras.blank?
      ''
    else
      URI.encode("?" + _paras.reduce(''){|p,m|p+"#{m}=#{para[m.to_sym]}"})
    end
  end

  def filter_url para
    "&filter=#{para[:filter]}"  if para[:filter]
  end

  def typ_url para
    _paras = ['tag','rtyp','typ'].select{|m| !para[m.to_sym].blank?}
    if _paras.blank?
      ''
    else
      URI.encode("&" + _paras.reduce(''){|p,m|p+"#{m}=#{para[m.to_sym]}"})
    end
  end

  def plugin_list
    _tag = params[:tag]
    _where = _tag.blank? ? "" : "keywords like '%#{_tag}%'"
    _filter = ""
    _order = "id desc"
    case params[:filter]
    when 'comments'
      _order = "comment desc"
    when 'downloads'
      _order = "downnum desc" 
    when 'favors'
      _order = "collect desc"
    when "ie8"
      _filter = "browser <= 8" 
    when "ie6"
      _filter= "browser = 6"           
    end

    _typ = params[:typ]
    _where_typ = (_typ.blank? ? {} : ["typ like ?","%#{_typ}%"])
    
    _rtyp = params[:rtyp]
    _where_rtyp = (_rtyp.blank? ?  {} : ["root_typ like ?","%#{_rtyp}%"])


    _items = Plugin.where({:recsts => '0'}).where(_where).where(_filter).where(_where_typ).where(_where_rtyp)
    @items = data_list(_items.order(_order)).includes(:mem)
    @count = _items.count
  end


  def ask_list
    _order_by = 'id desc'
    _order_by = "#{params[:order]} desc" if ['created_at','money'].include? params[:order]
    _where = {}
    
    if params[:order] == 'answer'
      _where =  {:answer=> 0}
    end

    if params[:order] == 'money'
      _where =  {:status=> 'UNSOLVE'}
    end
    
    @items = data_list(Ask.where(_where).order(_order_by)).includes(:mem)
    @count = Ask.where(_where).count
  end


  def code_host
    Code.select("id,title,comment + collect as num").order('num desc').limit(9).offset(0)
  end
end

class Comment < ActiveRecord::Base
	belongs_to :mem 

  def friendly_time  
    created_at.friendly_i18n  
  end

  def isme? mem
    mem.id == mem_id
  end

  def update_num
    target.update_attributes({:comment=> Comment.where(:typ=>typ,:idcd=>idcd).count})
  end

  def target
    typ.capitalize.constantize.send :find,idcd
  end

  def link
    "/#{typ}/#{idcd}"
  end

  def raw_con
    CGI::escapeHTML(con).gsub(/&lt;pre(.+?)&gt;/){ |m|
      "<pre #{CGI::unescapeHTML($1)}>"
    }.gsub(/&lt;\/pre&gt;/,'</pre>')
  end
  
end

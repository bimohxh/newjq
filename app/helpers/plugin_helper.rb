module PluginHelper
  def related_plugins item
    _rids = Plugin.where(["recsts = '0' and typ in ('#{item.typ.split(',').join("','")}')  and id != ?",item.id]).order('id desc').limit(3).offset(0).pluck("id")
    Plugin.where({:id=> _rids})
  end
end

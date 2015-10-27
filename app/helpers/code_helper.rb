module CodeHelper
  def rand_color index
    ["#8CC8EC","#333","#FF7461","#B094DE","#F4CF77","#A2C746","#A2C746","#3D4A5B","#DA6868","#583D5B","#DA8368"][index % 11]
  end

  def rand_symb index
    ["</>","{ }","<?>","<:>","$()","[-]"][index % 6]
  end

  def packages
    require 'find'
    _folder = Rails.root.to_s + '/public/package/'  
    _categories = sub_directories _folder

    _categories.map do |item|
      _subs = sub_directories "#{Rails.root.to_s}/public/package/#{item}"
      
       _files = _subs.map do |sub|
         {sub.to_sym=> sub_files("#{Rails.root.to_s}/public/package/#{item}/#{sub}")}
       end

      {item.to_sym=> _files}
    end
  end
end

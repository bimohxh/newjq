class UploadController < ApplicationController
  before_filter :test_file
  skip_before_filter :has_info?

  def get_filename(file)
    "#{Time.now.strftime("%y%m%d%H%M%S")}#{rand(99).to_s}#{session[:mem].to_s}.#{file.original_filename.split('.').last}"
  end

  #插件包
  def pluginzip 
    _file = params[:filedata]
    _file_name = get_filename(_file)
    _path = "#{Rails.application.config.down_dir}#{_file_name}" 
    File.open(_path, "wb+") do |f|
      f.write(_file.read)
    end
    
    render text: {status: true,src: _file_name}.to_json
  end

  def pic
    _file = params[:filedata]
    _folder = params[:folder]
    _width = params[:width].to_i
    _height =  params[:height].to_i
    _file_name = get_filename(_file)
    _path = upload_file(_file,_file_name,_folder,_width,_height)
    #if params[:oss] = 'aliyun'
    #  _path = aliyun_upload File.open("#{Rails.application.config.assets_dir}/#{_folder}/#{_file_name}"),"#{_folder}/#{_file_name}"
    #end
    _path = aliyun_upload File.open("#{Rails.root}/public/upload/#{_folder}/#{_file_name}"),"#{_folder}/#{_file_name}"
    render text: {status: true,file_path: "#{Rails.application.config.source_access_path}#{_folder}/#{_file_name}",src: _file_name}.to_json
  end 


  #demo
  def demo    
    _file = params[:filedata]
    _file_name = get_filename(_file)
    _path = "#{Rails.application.config.demo_dir}#{_file_name}"

    File.open(_path, "wb+") do |f|
      f.write(_file.read)
    end

    _folder = _file.original_filename.split('.')[0] + '-' +Time.now.strftime("%y%m%d%H%M%S")
    unzip_file(_path, "#{Rails.application.config.demo_dir}#{_folder}")

    File.delete(_path)
    render text: {status: true,src: _folder}.to_json
  end

  #视频
  def video
    _file = params[:filedata]
    _file_name = get_filename(_file)
    upload_qiniu(_file,_file_name) 
    render text: {status: true,url: _file_name}.to_json
  end

end

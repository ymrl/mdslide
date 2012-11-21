module Mdslide

  def Mdslide.find_file file, dir_list
    dir_list.each do |dir_path|
      if File.exist?(dir_path + file)
        return dir_path + file
      end
    end
    return nil
  end

  def Mdslide.find_path path, dir_list
    dir_list.each do |dir_path|
      if File.exist?(dir_path + path)
        return dir_path
      end
    end
    return nil
  end

  def Mdslide.get_directories current = nil
    dirs = [CONFIG_DIR,ASSETS_DIR]
    dirs.unshift current if current 
    return dirs
  end

  def Mdslide.find_js_path file,current = nil
    dirs = Mdslide.get_directories(current).map{|e| "#{e}/js/"}
    return Mdslide.find_file file,dirs
  end

  def Mdslide.find_css_path file,current = nil
    dirs = Mdslide.get_directories(current).map{|e| "#{e}/css/"}
    return Mdslide.find_file file,dirs
  end

end


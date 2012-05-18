require 'yaml'
module Mdslide
  CONFIG_DIR = File.expand_path('~/.mdslide')
  Defaults = {
    :theme => 'white',
    :bind  => '127.0.0.1',
    :port  => '3000',
    :title => 'Slides converted by Mdslide',
  }

  def Mdslide.load_config config_file=(CONFIG_DIR + '/config.yaml')
    config_path = File.expand_path(config_file)
    my_config = nil
    if File.exist? config_path
      my_config = YAML.load_file(config_path)
      Themes.merge!   my_config[:themes]
      Defaults.merge! my_config[:config]
    end
  end

  Mdslide.load_config
end

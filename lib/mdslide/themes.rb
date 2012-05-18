require 'yaml'
module Mdslide
  Themes =  YAML.load_file(File.dirname(__FILE__)+'/../../assets/themes.yaml')
end

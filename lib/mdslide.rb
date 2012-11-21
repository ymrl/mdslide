$:.unshift(File.dirname(__FILE__)) unless
  $:.include?(File.dirname(__FILE__)) || $:.include?(File.expand_path(File.dirname(__FILE__)))

require 'mdslide/themes'
require 'mdslide/config'
require 'mdslide/path'
require 'mdslide/creator'

module Mdslide
  VERSION = '3.2.0'
end

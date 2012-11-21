require 'rubygems'
require 'kramdown'
require 'erb'

module Mdslide

  class Creator
    attr_reader :stylesheets,:scripts,:theme_stylesheets,:theme_scripts
    attr_accessor :title
    def initialize
      @stylesheets = ['base.css']
      @scripts = ['jquery.min.js','slides.js']
      @theme_scripts     = []
      @theme_stylesheets = []

      @page_template = File.open(File.dirname(__FILE__)  + '/../../templates/page.html.erb','r'){|r| erb = ERB.new(r.read)}
      @slide_template = File.open(File.dirname(__FILE__) + '/../../templates/slide.html.erb','r'){|r| erb = ERB.new(r.read)}
      @title = 'Slides converted by Mdslide'
    end

    def set_theme name
      theme = Themes[name.to_sym]
      if theme
        theme[:css] && @theme_stylesheets.replace(theme[:css])
        theme[:js]  && @theme_scripts.replace(theme[:js])
      end
      return theme
    end

    def get_binding
      binding
    end

    def convert_markdown md
      body = ''
      md.gsub(/\r\n?/, "\n").split(/^\/\/+$/).map do |slide|
        if slide =~ /(^|\s)(https?:\/\/[^\s]+)($|\s)/
          slide.gsub!(/(^|\s)(https?:\/\/[^\s]+)($|\s)/){"#{$1}[#{$2}](#{$2})#{$3}"}
        end
        if slide =~ /(^|\s)@([a-zA-Z0-9_]+)($|\s)/
          slide.gsub!(/(^|\s)@([a-zA-Z0-9_]+)($|\s)/, "#{$1}[@#{$2}](https://twitter.com/#{$2})#{$3}")
        end
        body += @slide_template.result(self.get_binding{Kramdown::Document.new(slide).to_html})
      end
      @page_template.result(self.get_binding{body})
    end
  end
end


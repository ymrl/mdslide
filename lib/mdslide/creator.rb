require 'redcarpet/compat'
require 'erb'

module Mdslide
    Themes = {
      'black' => 'black.css',
      'white' => 'white.css',
      'takahashi' => 'takahashi.css',
    }

  class Creator
    attr_reader :stylesheets,:scripts
    attr_accessor :title
    def initialize
      @stylesheets = ['base.css']
      @scripts = ['jquery.min.js','slides.js']
      @converter =  Redcarpet::Markdown.new(Redcarpet::Render::HTML, :autolink => true, :space_after_headers => true)
      @page_template = File.open(File.dirname(__FILE__)  + '/../../templates/page.html.erb','r'){|r| erb = ERB.new(r.read)}
      @slide_template = File.open(File.dirname(__FILE__) + '/../../templates/slide.html.erb','r'){|r| erb = ERB.new(r.read)}
      @title = 'Slides converted by Mdslide'
    end

    def set_theme name
      theme = Themes[name]
      @stylesheets.pop while @stylesheets.length > 1
      if theme
        @stylesheets.push theme
      end
    end

    def get_binding
      binding
    end

    def convert_markdown md
      body = ''
      md.split(/^\/\/+$/).map do |slide|
        body += @slide_template.result(self.get_binding{@converter.render(slide)})
      end
      @page_template.result(self.get_binding{body})
    end
  end
end


#coding:UTF-8
require 'rubygems'
require 'args_parser'
require 'mdslide'
require 'yaml'
require 'fileutils'

module Mdslide
  ASSETS_DIR = File.expand_path(File.dirname(__FILE__) + '/../../assets')

  def Mdslide.command argv=ARGV
    parser = ArgsParser.parse argv do
      arg :version,"Shows Mdslide Version", :alias => :v
      arg :help,   "Shows Help",      :alias => :h
      arg :input,  "Input File",      :alias => :i
      arg :theme,  "Theme",           :alias => :t, :default => Mdslide::Defaults[:theme]
      arg :bind,   "Bind IP Address", :alias => :b, :default => Mdslide::Defaults[:bind ]
      arg :port,   "Port Number",     :alias => :p, :default => Mdslide::Defaults[:port ]
      arg :title,  "Title",           :alias => :T, :default => Mdslide::Defaults[:title]
      arg :output, "Output File",     :alias => :o
      arg :'without-assets-dir', "Does not create js/css directory"
      arg :'without-css-dir',    "Does not create css directory"
      arg :'without-js-dir',     "Does not create js directory"
    end
    if parser.has_option? :version
      puts VERSION
      return 0
    elsif parser.has_option? :help or !parser.has_param?(:input)
      puts "mdslide [options] -i <Input File>"
      puts parser.help
      return 0
    end

    creator = Creator.new
    creator.title = parser[:title]
    default_theme = parser[:theme]

    file_path = File.expand_path(parser[:input])
    dir_path = File.dirname(file_path)

    if parser.has_param? :output
      output_path = File.expand_path(parser[:output])
      output_dir_path = File.dirname(output_path)

      creator.set_theme default_theme
      input = nil
      File.open(file_path,'r'){|r| input = r.read }
      File.open(output_path,'w'){|f| f.puts creator.convert_markdown(input)}

      output_js  = !parser[:"without-assets-dir"] and !parser[:"without-js-dir"]
      output_css = !parser[:"without-assets-dir"] and !parser[:"without-css-dir"]
      src_dirs = [dir_path,CONFIG_DIR,ASSETS_DIR].delete_if{|e| e == output_dir_path}
      
      if output_js
        js_path = output_dir_path+'/js'
        Dir::mkdir(js_path) unless File.exist?(js_path) and File.directory?(js_path)
        (creator.scripts + creator.theme_scripts).each do |e| 
          src_file = Mdslide.find_js_path(e)
          FileUtils.cp("#{src_file}",js_path)
          #src_dir = Mdslide.find_path(e,src_dirs.map{|m| "#{m}/js/"})
          #FileUtils.cp("#{src_dir}/#{e}",js_path) if src_dir
        end
      end
      if output_css
        css_path = output_dir_path+'/css'
        Dir::mkdir(css_path) unless File.exist?(css_path) and File.directory?(css_path)

        (creator.stylesheets + creator.theme_stylesheets).each do |e| 
          src_file = Mdslide.find_css_path(e)
          FileUtils.cp("#{src_file}",css_path)
          #src_dir = Mdslide.find_path(e,src_dirs.map{|m| "#{m}/css/"})
          #FileUtils.cp("#{src_dir}/#{e}",css_path) if src_dir
        end
      end

    else
      require 'webrick'
      srv = WEBrick::HTTPServer.new( 
        :BindAddress => parser[:bind],
        :DoNotReverseLookup => true,
        :Port => parser[:port],
        :MimeTypes => WEBrick::HTTPUtils::DefaultMimeTypes.merge({"js"=>"application/javascript"})
      )
      srv.mount_proc '/' do |req,res|
        root_path = nil
        if req.path != '/'
          root_path = Mdslide.find_path(req.path,[dir_path,CONFIG_DIR,ASSETS_DIR])
          if root_path
            si = WEBrick::HTTPServlet::FileHandler.get_instance(srv, root_path)
            si.service(req,res)
          end
        end

        if !root_path
          Mdslide.load_config
          m = req.path.match(/\/(.+)/)
          theme = (m && m[1]) || default_theme
          creator.set_theme theme
          File.open(file_path,'r'){|r| input = r.read }

          res.body = creator.convert_markdown(input)
          res['Content-Type'] = 'text/html'
          res['Content-Length'] = res.body.bytesize
        end
      end
      Signal.trap(:INT){ srv.shutdown }
      srv.start
    end
    return 0
  end
end

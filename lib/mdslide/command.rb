#coding:UTF-8
require 'args_parser'
require 'mdslide'
require 'yaml'
require 'fileutils'

module Mdslide

  ASSETS_DIR = File.expand_path(File.dirname(__FILE__) + '/../../assets')
  CONFIG_DIR = File.expand_path('~/.mdslide')

  def Mdslide.find_path path, dir_list
    dir_list.each do |dir_path|
      if File.exist?(dir_path + path)
        return dir_path
      end
    end
    return nil
  end

  def Mdslide.command
    parser = ArgsParser.parse ARGV do
      arg :help,   "Shows Help",      :alias => :h
      arg :input,  "Input File",      :alias => :i
      arg :theme,  "Theme",           :alias => :t, :default => 'white'
      arg :bind,   "Bind IP Address", :alias => :b, :default => '127.0.0.1'
      arg :port,   "Port Number",     :alias => :p, :default => '3000'
      arg :title,  "Title",           :alias => :T, :default => 'Slides converted by Mdslide'
      arg :output, "Output File",     :alias => :o
      arg :'without-assets-dir', "Does not create js/css directory"
      arg :'without-css-dir',    "Does not create css directory"
      arg :'without-js-dir',     "Does not create js directory"
    end

    if parser.has_option? :help or !parser.has_param?(:input)
      puts "mdslide [options] -i <Input File>"
      puts parser.help
      return 0
    end

    config_path = File.expand_path(CONFIG_DIR + '/config.yaml')
    my_config = nil
    if File.exist? config_path
      my_config = YAML.load_file(config_path)
      Themes.merge! my_config[:themes]
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
      File.open(file_path,'r'){|r| input = r.read.force_encoding(Encoding::UTF_8) }
      File.open(output_path,'w'){|f| f.puts creator.convert_markdown(input)}

      output_js  = !parser[:"without-assets-dir"] and !parser[:"without-js-dir"]
      output_css = !parser[:"without-assets-dir"] and !parser[:"without-css-dir"]
      src_dirs = [dir_path,CONFIG_DIR,ASSETS_DIR].delete_if{|e| e == output_dir_path}
      
      if output_js
        js_path = output_dir_path+'/js'
        Dir::mkdir(js_path) unless Dir.exist?(js_path)

        (creator.scripts + creator.theme_scripts).each do |e| 
          src_dir = Mdslide.find_path(e,src_dirs.map{|m| "#{m}/js/"})
          FileUtils.cp("#{src_dir}/#{e}",js_path) if src_dir
        end
      end
      if output_css
        css_path = output_dir_path+'/css'
        Dir::mkdir(css_path) unless Dir.exist?(css_path)

        (creator.stylesheets + creator.theme_stylesheets).each do |e| 
          src_dir = Mdslide.find_path(e,src_dirs.map{|m| "#{m}/css/"})
          FileUtils.cp("#{src_dir}/#{e}",css_path) if src_dir
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
          m = req.path.match(/\/(.+)/)
          theme = (m && m[1]) || default_theme
          creator.set_theme theme
          File.open(file_path,'r'){|r| input = r.read.force_encoding(Encoding::UTF_8) }

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

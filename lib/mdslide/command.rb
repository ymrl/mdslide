#coding:UTF-8
require 'ArgsParser'
require 'mdslide'
require 'yaml'

module Mdslide

  ASSETS_DIR = File.expand_path(File.dirname(__FILE__) + '/../../assets')
  CONFIG_DIR = File.expand_path('~/.mdslide')

  def Mdslide.command parser = ArgsParser.parser
    parser.bind(:help,   :h, "Shows Help")
    parser.bind(:output, :o, "Output")
    parser.bind(:input,  :i, "Input")
    parser.bind(:theme,  :t, "theme","white")
    parser.bind(:server, :s, "Start HTTP Server")
    parser.bind(:bind,   :b, "Bind IP Address for HTTP Server")
    parser.bind(:port,   :p, "Setting Port Number for HTTP Server")
    parser.bind(:title, :T, "Set Presentaion Tiltle")
    parser.comment('without-assets-dir', "Does not create js/css directory")
    parser.comment('without-css-dir',    "Does not create css directory")
    parser.comment('without-js-dir',     "Does not create js directory")
    
    params = parser.parse(ARGV)
    
    if parser.params[:help] or !parser.params[:input]
      puts "mdslide [options] -i <Input File>"
      puts parser.help
      return 0
    end

    config_path = File.expand_path(CONFIG_DIR + '/config.yaml')
    if File.exist? config_path
      my_config = YAML.load_file(config_path)
      Themes.merge! my_config[:themes]
    end

    output = parser.params[:output]
    f = STDOUT
    if output
      f = File.open(File.expand_path(parser.params[:output]),'w')
    end

    creator = Creator.new
    if parser.params[:title]
      creator.title = parser.params[:title]
    end


    default_theme = parser.params[:theme]
    creator.set_theme default_theme

    file = File.expand_path(parser.params[:input])
    dir_path = File.dirname(file)

    input = nil
    File.open(file,'r'){|r| input = r.read.force_encoding(Encoding::UTF_8) }
    creator.convert_markdown(input)

    server = parser.params[:server]

    if !server or output
      f.puts creator.convert_markdown(input)
 
    end

    if server
      require 'webrick'
      srv = WEBrick::HTTPServer.new({ :BindAddress => (parser.params[:bind] || '127.0.0.1'),
                                      :DoNotReverseLookup => true,
                                      :Port => (parser.params[:port] || 3000)})
      srv.mount_proc '/' do |req,res|
        file_path = nil
        root_path = dir_path
        if req.path != '/'
          if File.exist?(dir_path + req.path)
            file_path = dir_path + req.path
          elsif File.exist?(CONFIG_DIR + req.path)
            file_path = CONFIG_DIR + req.path
            root_path = CONFIG_DIR
          elsif File.exist?(ASSETS_DIR + req.path)
            file_path = ASSETS_DIR + req.path
            root_path = ASSETS_DIR
          end

          if file_path
            si = WEBrick::HTTPServlet::FileHandler.get_instance(srv, root_path)
            si.service(req,res)
          end
        end

        if !file_path
          m = req.path.match(/\/(.+)/)
          theme = (m && m[1]) || default_theme
          creator.set_theme theme
          res['Content-Type'] = 'text/html'
          File.open(file,'r'){|r| input = r.read.force_encoding(Encoding::UTF_8) }
          res.body = creator.convert_markdown(input)
        end
      end
      Signal.trap(:INT){ srv.shutdown }
      srv.start
    end

    if output
      f.close
      dir = File.dirname(File.expand_path(parser.params[:output]))
      js  = !parser.params[:"without-assets-dir"] and !parser.params[:"without-js-dir"]
      css = !parser.params[:"without-assets-dir"] and !parser.params[:"without-css-dir"]
      
      if js
        system "cp -r #{File.expand_path(File.dirname(__FILE__) + '/../../assets/js')} #{dir}"
      end
      if css
        system "cp -r #{File.expand_path(File.dirname(__FILE__) + '/../../assets/css')} #{dir}"
      end

    end

    return 0
  end
end

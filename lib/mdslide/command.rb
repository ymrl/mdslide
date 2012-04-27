#coding:UTF-8
require 'ArgsParser'
require 'mdslide'

module Mdslide

  
  def Mdslide.command parser = ArgsParser.parser
    parser.bind(:help,   :h, "Shows Help")
    parser.bind(:output, :o, "Output")
    parser.bind(:input,  :i, "Input")
    parser.bind(:theme,  :t, "theme")
    parser.bind(:server, :s, "Start HTTP Server")
    parser.bind(:bind,   :b, "Bind IP Address for HTTP Server")
    parser.bind(:port,   :p, "Setting Port Number for HTTP Server")
    parser.bind(:title, :T, "set Presentaion tiltle")
    parser.comment('without-assets-dir', "Does not create js/css directory")
    parser.comment('without-css-dir',    "Does not create css directory")
    parser.comment('without-js-dir',     "Does not create js directory")
    
    params = parser.parse(ARGV)
    
    if parser.params[:help] or !parser.params[:input]
      puts "mdslide [options] -i <Input File>"
      puts parser.help
      return 0
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


    default_theme = 'white'
    if parser.params[:theme]
      default_theme =  parser.params[:theme]
      creator.set_theme default_theme
    end

    file = File.expand_path(parser.params[:input])

    input = nil
    File.open(file,'r'){|r| input = r.read }
    creator.convert_markdown(input)

    server = parser.params[:server]

    if !server or output
      f.puts creator.convert_markdown(input)
 
    end

    if server
      require 'webrick'
      srv = WEBrick::HTTPServer.new({ :DocumentRoot => './',
                                      :BindAddress => (parser.params[:bind] or '127.0.0.1'),
                                      :DoNotReverseLookup => true,
                                      :Port => (parser.params[:port] or 3000)})
      srv.mount '/js', WEBrick::HTTPServlet::FileHandler, File.expand_path(File.dirname(__FILE__) + '/../../assets/js')
      srv.mount '/css', WEBrick::HTTPServlet::FileHandler, File.expand_path(File.dirname(__FILE__) + '/../../assets/css')
      srv.mount_proc '/' do |req,res|
        theme = default_theme
        if req.path =~ /\/(.+)/
          theme = $1
        end
        creator.set_theme theme
        res['Content-Type'] = 'text/html'
        File.open(file,'r'){|r| input = r.read }
        res.body = creator.convert_markdown(input)
      end
      Signal.trap(:INT){ srv.shutdown }
      srv.start
    end

    if output
      f.close
      dir = File.dirname(File.expand_path(parser.params[:output]))
      js = !parser.params[:"without-assets-dir"] and !parser.params[:"without-js-dir"]
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

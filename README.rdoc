= mdslide

* http://github.com/ymrl/mdslide
* https://rubygems.org/gems/mdslide

== DESCRIPTION:

Mdslide is an slide generator for presentation based on Markdown (RedCarpet). It can convert extended Markdown file to HTML it can show as aslides and/or outlines. It outputs HTML, CSS and Javascript files, also you can use this HTTP Server for your convinience.

== INSTALL:

  gem instal mdslide

== REQUIREMENTS:

* Ruby + Rubygems

== DIPENDENCIES:

* args_parser
* kramdown

Those will be installed with mdslide through rubygems, automatically

== USAGE:

Firstly, You need to write Markdown file.

  Presentation Tilte
  ==========
  
  your name  
  2012/04/24
  
  ////
  
  First Slide
  ------------
  
  * For split slide, you must write more than 2 slashes
  * and others, you have to read [Markdown Syntax References](http://daringfireball.net/projects/markdown/syntax)

If you want to get HTML, CSS and Javascript files for your web server, use -o option

  $ mdslide -i foo.md -o bar.md

Viewing only, Web server feature is useful. Without -o option, starting web server on port 3000 on your PC and you can preview on http://localhost:3000/

  $ mdslide -i foo.md 
  # you can see your slides at http://localhost:3000/
  # and if you want in other theme, go http://localhost:3000/black

Others can be shown with --help option

  $ mdslide --help

=== CONFIGURATIONS
`mdslide` command reads ~/.mdslide/config.yaml if it exists. You can describe your own settings and themes in YAML format.

  :themes:
    :my-theme:
      :css:
        - my-theme.css
        - color-black.css
        - transition-crossfade.css
      :js:
        - my-theme.js
  :config:
    :bind: 0.0.0.0
    :title: "My Slide"
    :port: 10080
    :theme: white-crossfade

CSS/JS files included in customized themes will be loaded in  this order: relative path from the Markdown file -> relative path from your configuration directory (~/.mdslide/) -> assets directory of mdslide library (default). If you want to create your own theme, locate files on ~/.mdslide/.

== LICENSE:

(The MIT License)

Copyright (c) 2012 Allu Yamane

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
'Software'), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

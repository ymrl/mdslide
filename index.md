Mdslide Introduction
=====================

ymrl (https://github.com/ymrl/)

////////////////////

What is Mdslide?
----------------

* Generates HTML-based slideshow from Markdown
  * Easy to edit contents
	* Easy to share with your web server
	* Anybody can see slideshow on Web browser
* This page is generated with Mdslide, of course!

///////////

How to Install
----------------
* You can install with RubyGems

        gem install mdslide

* And write some markdown texts...
  * When you want to go next page, insert 2+ slash
//////////

Example
-------------
    First Slide
		==========
		My Name
		/////////
		Second Slide
		///////////
		* List
		* List
		* List
		///////
		Third Slide
		------------
		> quote

/////////

Generation
--------------

    mdslide -i foobar.md -o foobar.html

///////////

WEBrick Server
--------------
* You can preview your slideshow without any file-output
* run `mdslide` command without -o option

        mdslide -i foobar.md

  and go to http://localhost:3000/


スライド作成システムMdslide
==============
[ymrl](https://twitter.com/ymrl)

//////

Mdslideとは
------------
* Markdownを使ったスライド作成システム
* Rubygemsでインストール可能
* HTML5 + JavaScriptによるスライド
* MIT Lisence

//////

Mdslideの機能
-------------
* Markdownファイルの変換
* HTML+CSS+JavaScriptファイルの出力
* Webサーバー機能
//////
Mdslide用Markdown
----------------
	First Slide
	==========
	My Name
	/////
	Second Slide
	------
	* list 1
	* list 2
	* list 3
/////
スライドに変換
--------------
	$ mdslide -i hoge.md -o hoge.html
//////
First Slide
==========
My Name
/////
Second Slide
------
* list 1
* list 2
* list 3
/////////
Mdslide Markdown
--------------
* /が複数個連続しているだけの行をスライド区切りとして扱う
////////
HTTPサーバー機能
--------------
	$ mdslide -i hoge.md -s

* http://localhost:3000/
* http://localhost:3000/black
* 変換前・変換後をそれぞれ保存しなくていい
//////////
テーマ機能
-------------
	$ mdslide -i hoge.md -o hoge.html -t black

* 2012年4月現在 white/black/takahashi のみ
  * 増やしたい
* サーバー起動後、/takahashi とかでプレビュー
* デフォルトでサイズ調整機能あり
//////

アウトライン表示
-------------
右下の [View Outline](#outline) をクリック

//////
便利な点
--------
* Webブラウザさえあれば見られる
* スライドの見栄えとか気にしなくていい
	* 作業量が少ない
	* 発表内容に集中できる
* 全体を俯瞰しやすい
/////
画像も使える
----------
![kitty](kitty.jpg)

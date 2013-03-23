#!/usr/bin/ruby
# encoding:utf-8

require "nkf"
require "cgi"
require "open-uri"

#ヒアドキュメントで表示
puts <<-EOS
Content-type: text/html\n\n
<!DOCTYPE html>
	<head>
		<meta charset ="UTF-8"/>
		<title>This is Your Wish Lists?</title>
	</head>
	<body>

EOS

flag = "stop"
file = ""
item = []
items = []
f1 =""
cgi = CGI.new
url = cgi["address"]

#最初にアドレスをチェック
if url =~ /^http:\/\/www.amazon.co.jp/

	#htmlを取得してエンコードを変換（SJISからUTF-8に）
	#htmlは配列fileの第一要素（file[0]）に格納
	open(url) do |f|
		file = NKF.nkf('-Sw',f.read)
	end
	
	#一行ごとに処理
	file.each_line do |line|
		#商品名
		if line =~ /small productTitle/
			flag = "on" 
		#改行に対応
		elsif flag == "on" 
			if line =~ /a href/
				item_name = line.gsub(/<[^<>]*>/,"")
			flag = "stop" 
			#配列に格納
			item << item_name
			end
		end
	
		#価格
		if line =~ /wlPriceBold/
			line =~ /￥ [0-9,]*/
			item_price = $&
			#item_price = line.gsub(/<[^<>]*>/,"").gsub(/.*¥/,"¥")
			#配列に格納
			item << item_price
		end
	
		#写真
		if line =~ /Product Image/
			line =~ /src="http.*jpg/
			item_img = $&.to_s.sub(/src="/,"")
			item << item_img
		end
	
		#商品ごとにまとめる
		#各商品のための配列はクリア
		if item.length == 3
			items << item 
			item = []
		end

		#配列は[[商品名,価格,写真],[商品名,価格,写真]...]
	end
	
	#配列を表示用に整形
	items.each do |x|
		x[0] = '		<img src="'+x[0]+'" alt="item_img"/>'
		x[1] = '		<p>'+x[1].delete("\n")+'</p>'
		x[2] = '		<p>'+x[2].to_s+'</p>'
	end
	
	#全ての商品を出力
	items.each do |x|
		puts x
	end

	puts <<-EOS
		</body>
	</html>
	EOS
	
else
	puts "error!"
	puts <<-EOS
		</body>
	</html>
	EOS
end


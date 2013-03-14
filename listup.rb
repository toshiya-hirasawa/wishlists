# encoding:utf-8
flag = "stop"

file = []
item = []
items = []

require 'open-uri'
url = "http://www.amazon.co.jp/gp/registry/wishlist/VP4L4DR1U102/ref=topnav_lists_2"
open(url,"r:Shift_JIS") do |f|
	file << f.read.encode("UTF-8","Shift_JIS")
end

file[0].each_line do |line|
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
	if item.length == 3
		items << item 
		item = []
	end
end

#配列を表示用に整形
items.each do |x|
	x[0] = '		<img src="'+x[0]+'" alt="item_img"/>'
	x[1] = '		<p>'+x[1].delete("\n")+'</p>'
	x[2] = '		<p>'+x[2].to_s+'</p>'
end

#ヒアドキュメントで表示
puts <<-EOS
<!DOCTYPE html>
	<head>
		<meta charset ="UTF-8"/>
		<title>test</title>
	</head>
	<body>
EOS
items.each do |x|
	puts x
end

puts <<-EOS
	</body>
</html>
EOS

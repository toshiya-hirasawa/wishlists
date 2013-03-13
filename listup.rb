flag = "stop"
file = open("wish.html")

item = []

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
		line =~ /¥ [0-9,]*/
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
end

puts item

file.close

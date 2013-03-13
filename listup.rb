flag = "stop"
item = Hash.new
item_name = ""
item_price = ""
file = open("wish.html")

file.each_line do |line|
	#商品名
	if line =~ /small productTitle/
		flag = "on" 
		#改行に対応
	elsif flag == "on" 
		if line =~ /a href/
			item_name = line.gsub(/<[^<>]*>/,"")
		flag = "stop" 
		end
	end

	#価格
	if line =~ /wlPriceBold/
		item_price = line.gsub(/<[^<>]*>/,"").gsub(/.*¥/,"¥")
	end
	
	#連想配列に追加
	item[item_name] = item_price
end

#改行を削除して連想配列を表示
item.each do |name,price|
	puts name.delete("\n") + "\t" + price
end
file.close

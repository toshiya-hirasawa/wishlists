flag = "stop"
item = Hash.new
item_name = ""
item_price = ""
file = open("wish.html")

file.each_line do |line|
	if line =~ /small productTitle/
		flag = "on" 
	elsif flag == "on" 
		if line =~ /a href/
			item_name = line.gsub(/<[^<>]*>/,"")
		flag = "stop" 
		end
	end

	if line =~ /wlPriceBold/
		item_price = line.gsub(/<[^<>]*>/,"").gsub(/.*¥/,"¥")
	end
	
	item[item_name] = item_price
end

item.each do |name,price|
	puts name.delete("\n") + "\t" + price
end
file.close

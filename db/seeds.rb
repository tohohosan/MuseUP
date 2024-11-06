# seeds.rb
categories = ["歴史", "自然", "美術", "民族", "民俗", "科学技術", "文学", "人物"]
categories.each do |category_name|
    Category.find_or_create_by(name: category_name)
end

require 'spec_helper'

describe Category do 
	it "saves itself" do 
		category = Category.new(name: "Action")
		category.save
		expect(Category.first).to eq(category)
	end

	it "has many videos" do
		drama = Category.create(name: "drama")
		monk = Video.create(title: "monk", description: "crime drama", category: drama)
		gotham = Video.create(title: "Gotham", description: "batman begins again", category: drama)
		expect(drama.videos).to eq([gotham, monk])
	end
 end 

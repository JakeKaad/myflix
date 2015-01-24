require 'spec_helper'

describe Video do 
 it { should belong_to(:category) }
 it { should validate_presence_of(:title) }
 it { should validate_presence_of(:description) }

 describe "search_by_title" do
  it "returns an empty array if there is no match" do
    monk = Video.create(title: "monk", description: "monky monk monk")
    monkeys = Video.create(title: "monkeys", description: "monkey time!")
    expect(Video.search_by_title("walruses")).to eq([])
  end

  it "returns an array of 1 video if there is an exact match" do
    monk = Video.create(title: "monk", description: "monky monk monk")
    monkeys = Video.create(title: "monkeys", description: "monkey time!")
    expect(Video.search_by_title("monkeys")).to eq([monkeys])
  end

  it "returns an array of 1 video for a partial match" do 
    monk = Video.create(title: "monk", description: "monky monk monk")
    monkeys = Video.create(title: "monkeys", description: "monkey time!")
    expect(Video.search_by_title("monke")).to eq([monkeys])
  end

  it "returns an array of all matches ordered by created_at " do 
    monk = Video.create(title: "monk", description: "monky monk monk", created_at: 1.day.ago)
    monkeys = Video.create(title: "monkeys", description: "monkey time!")
    expect(Video.search_by_title("mon")).to eq([monkeys, monk])
  end

  it "returns an empty array for an empty search query" do 
    monk = Video.create(title: "monk", description: "monky monk monk", created_at: 1.day.ago)
    monkeys = Video.create(title: "monkeys", description: "monkey time!")
    expect(Video.search_by_title("")).to eq([])
  end
 end
end
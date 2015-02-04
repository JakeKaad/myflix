require 'spec_helper'

feature "user interacts with the queue" do 
  scenario "user adds and reorders videos in the queue" do 
    action = Fabricate(:category)
    monk = Fabricate(:video, title: "Monk", category: action)
    gotham = Fabricate(:video, title: "Gotham", category: action)
    south_park = Fabricate(:video, title: "South Park", category: action)

    sign_in
    find("a[href='/videos/#{monk.id}']").click
    expect(page).to have_content monk.title 

    click_link "+ My Queue"
    expect(page).to have_content monk.title

    visit video_path(monk)
    expect(page).to_not have_content "+ My Queue"

    visit home_path
    find("a[href='/videos/#{gotham.id}']").click
    click_link "+ My Queue"
    visit home_path
    find("a[href='/videos/#{south_park.id}']").click
    click_link "+ My Queue"

    fill_in "video_#{monk.id}", with: 3 
    fill_in "video_#{gotham.id}", with: 1
    fill_in "video_#{south_park.id}", with: 2

    click_button "Update Instant Queue"

    expect(find("#video_#{gotham.id}").value).to eq("1")
    expect(find("#video_#{south_park.id}").value).to eq("2")
    expect(find("#video_#{monk.id}").value).to eq("3")
  end
end
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
  end
end
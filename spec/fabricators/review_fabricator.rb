Fabricator(:review) do 
  video_id { (1..99).to_a.sample }
  rating { (1..5).to_a.sample }
  content { Faker::Lorem.paragraph(2) }
end
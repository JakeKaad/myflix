# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

Category.create(name: "Cartoon")
Category.create(name: "TV Drama")
Category.create(name: "TV Action")

gotham = Video.create(title: "Gotham", 
						  description: "Discover the early days of Gotham before batman.",
						  small_cover_url: '/tmp/gotham.jpg',
						 	large_cover_url: '/tmp/gotham_large.jpg',
						 	category_id: 3)
Video.create(title: "Monk", 
						  description: "An obsessive compulsive detective does quirky things.",
						  small_cover_url: '/tmp/monk.jpg',
						 	large_cover_url: '/tmp/monk_large.jpg',
						 	category_id: 2)
Video.create(title: "South Park", 
						  description: "A group of 4 obscen children, in an obscene town, satirize world culture and politics.",
						  small_cover_url: '/tmp/south_park.jpg',
						 	large_cover_url: '/tmp/south_park.jpg',
						 	category_id: 1)
Video.create(title: "Futurama", 
						  description: "Space travel!",
						  small_cover_url: '/tmp/futurama.jpg',
						 	large_cover_url: '/tmp/futurama.jpg',
						 	category_id: 1)


jake = User.create(email: "jake@example.com", full_name: "Jake Kaad", password: "password")
Review.create(user: jake, video: gotham, rating: 5, content: "Best show ever.")



	
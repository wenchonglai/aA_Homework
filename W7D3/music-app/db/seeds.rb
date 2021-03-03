# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
User.destroy_all

user = User.new(email: "admin@gmail.com")
user.password = "password"
user.create!

user = User.new(email: "test@gmail.com")
user.password = "123456"
user.create!

Band.destroy_all

band = Band.create!(name: "Alexandrov Ensemble", image_url: "https://upload.wikimedia.org/wikipedia/commons/thumb/9/91/Ch%C3%B3r_aleksandrowa_i_balet_27_pa%C5%BAdziernika_2009_warszawa.JPG/533px-Ch%C3%B3r_aleksandrowa_i_balet_27_pa%C5%BAdziernika_2009_warszawa.JPG")
band = Band.create!(name: "Ministry of Culture", image_url: "https://upload.wikimedia.org/wikipedia/commons/thumb/6/63/Coat_of_arms_of_the_Soviet_Union_1.svg/440px-Coat_of_arms_of_the_Soviet_Union_1.svg.png")




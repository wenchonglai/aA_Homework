# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
require 'date'

User.destroy_all

user = User.new(username: 'admin', email: 'zsyzyork@gmail.com', password: 'password')
user.save

user = User.new(username: 'test', email: 'test@testing.com', password: 'testing')
user.save

Cat.destroy_all

cats = [ "dug", "bug", "rug", "mug", "tug", "hug", "jug", "lug", "pug", "vug", "fug",
  "drug", "plug", "smug", "slug", "snug", "thug", "chug", "glug", "trug",
  "shrug", "debug", "sprug", "almug",
  "humbug", "unplug", "bedbug", "mudbug", "redbug", "dorbug", "bedrug",
  "prodrug", "ladybug", "earplug", "billbug", "firebug", "goldbug", "tautaug", "lovebug", "antibug", "quahaug", "bearhug", "nondrug"
];

colors = ['brown', 'orange', 'white', 'black', 'ginger', 'blue', 'grey'];

cats.shuffle.each_with_index do |cat, i|
  Cat.create({
    birth_date: Date.jd(Date.today.jd - rand(5000)),
    color: colors.sample,
    name: cat,
    sex: ['M', 'F'].sample, 
    user_id: 1,
    url: "http://placekitten.com/#{200 + i}/#{200 + i}",
    description: "#{Faker::Creature::Dog.meme_phrase}. Such #{Faker::Adjective.positive}. wow"
  });
end

require 'faker'
require 'open-uri'
require 'csv'

Review.destroy_all
Order.destroy_all
User.destroy_all
Car.destroy_all

user = User.new(
  first_name: Faker::Name.first_name,
  last_name: Faker::Name.last_name,
  email: 'test@test.com',
  password: '123456'
)
image = URI.open("https://i.pravatar.cc/300")
user.avatar.attach(io: image, filename: "#{user.email}.jpg")
user.save

10.times do
  image = URI.open("https://i.pravatar.cc/300")
  user = User.new(
    email: Faker::Internet.email,
    password: 'motdepasse',
    first_name: Faker::Name.first_name,
    last_name: Faker::Name.last_name
  )
  user.avatar.attach(io: image, filename: "#{user.email}.jpg")
  user.save
end
users = User.all

cars_url = [
  "https://en.wikipedia.org/wiki/Ford_Transit",
  "https://en.wikipedia.org/wiki/Lamborghini_Aventador",
  "https://en.wikipedia.org/wiki/Renault_M%C3%A9gane",
  "https://en.wikipedia.org/wiki/Alfa_Romeo_Giulia_(2015)",
  "https://fr.wikipedia.org/wiki/Peugeot_307",
  "https://en.wikipedia.org/wiki/Chevrolet_Camaro",
  "https://en.wikipedia.org/wiki/Ford_Kuga"
]

cars_url.each do |url|
  html = URI.open(url)
  doc = Nokogiri::HTML.parse(html)
  locations = ['Paris', 'Lille', 'Bordeaux', 'Toulouse', 'Nantes']

  car = Car.new(
    name: doc.search('.mw-page-title-main').text,
    price_per_day: rand(100..1000),
    user: users.sample,
    location: locations.sample
  )

  image_url = "https:#{doc.search('table span a img').attr('src').value}"
  image_resized = image_url.gsub("280px", "700px")
  image = URI.open(image_resized)
  car.new_image.attach(io: image, filename: "#{car.name}.jpg")

  car.save
end

cars = Car.all
cars.each do |car|
  latest_end_date = Date.today
  5.times do
    start_date = Faker::Date.between(from: latest_end_date + 1, to: latest_end_date + 5)
    end_date = Faker::Date.between(from: start_date + 3, to: start_date + 5)

    latest_end_date = end_date

    Order.create(
      user: users.sample,
      car: car,
      start_date: start_date,
      end_date: end_date,
      state: rand(0..2)
    )
  end

  2.times do
    Review.create(
      user: users.sample,
      car: car,
      comment: Faker::Lorem.sentence,
      rating: rand(1..5)
    )
  end
end

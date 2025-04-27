# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)
# AdminUser.create!(email: 'admin@example.com', password: 'password', password_confirmation: 'password') if Rails.env.development?


AdminUser.find_or_create_by!(email: 'admin@store.com') do |a|
  a.password = 'password'
  a.password_confirmation = 'password'
end

# Provinces & taxes
provs = [
  { name: 'MB', gst: 5, pst: 7, hst: 0 },
  { name: 'ON', gst: 5, pst: 0, hst: 8 },
  { name: 'QC', gst: 5, pst: 9.975, hst: 0 },
]
provs.each { |p| Province.create_with(gst_rate: p[:gst], pst_rate: p[:pst], hst_rate: p[:hst]).find_or_create_by!(name: p[:name]) }

# Categories
%w[Lamps Rugs Pottery Glass].each { |c| Category.find_or_create_by!(name: c) }

# Products
Category.all.each do |cat|
  5.times do |i|
    prod = Product.find_or_initialize_by(name: "#{cat.name} Item #{i+1}")
    prod.update!(
      description: "A beautiful piece of #{cat.name.downcase}.",
      price: (i+1)*12.5,
      inventory_count: 10 + i*5
    )
    prod.categories = [cat]
  end
end

# Create a test user
User.find_or_create_by!(email: 'user@example.com') do |u|
  u.name     = 'Test User'
  u.password = 'password'
  u.password_confirmation = 'password'
  u.province = Province.find_by(name: 'MB')
end

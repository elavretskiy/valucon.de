emails = %w(admin@valucon.de user@valucon.de)

emails.each_with_index do |email, index|
  params = { email: email, password: 'password', password_confirmation: 'password', role: index }
  user = User.find_by(email: email) || User.create!(params)

  tasks = user.tasks
  next if tasks.present?
  100.times { tasks.create!(name: Faker::Lorem.sentence, description: Faker::Lorem.paragraph) }
end

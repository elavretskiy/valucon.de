# == Schema Information
#
# Table name: users
#
#  id              :integer          not null, primary key
#  email           :string           not null
#  password_digest :string           not null
#  role            :integer          default(1), not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

require 'faker'

FactoryGirl.define do
  factory :user do
    email { Faker::Internet.email }
    password 'password'
    role 1

    trait :admin do
      role 0
    end
  end

  factory :user_with_tasks, parent: :user  do |user|
    tasks { build_list :task, 50 }
  end
end

# == Schema Information
#
# Table name: tasks
#
#  id          :integer          not null, primary key
#  name        :string           not null
#  description :string
#  state       :string           not null
#  user_id     :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  uploads     :string           default([]), is an Array
#

require 'faker'

FactoryGirl.define do
  factory :task do
    name { Faker::Lorem.sentence }
    description { Faker::Lorem.paragraph }
    association :user, factory: :user
  end
end

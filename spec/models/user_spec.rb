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

require 'rails_helper'

RSpec.describe User, type: :model do
  it 'validates presence' do
    user = User.new
    user.save
    errors = user.errors.full_messages.uniq
    expect(errors.include?('Пароль не может быть пустым')).to be true
    expect(errors.include?('E-mail не может быть пустым')).to be true
    expect(errors.include?('E-mail имеет неверный формат')).to be true
  end

  it 'default role' do
    user = FactoryGirl.create(:user)
    expect(user.role).to eq 'is_user'
  end
end

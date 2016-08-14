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

class User < ActiveRecord::Base
  has_secure_password

  has_many :tasks, dependent: :destroy

  enum role: { is_admin: 0, is_user: 1 }

  validates :email, :role, :password, presence: true
  validates :email, uniqueness: true
  validates :email, email_format: { :message => 'имеет неверный формат' }
end

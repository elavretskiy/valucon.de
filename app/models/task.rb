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

class Task < ActiveRecord::Base
  include IndexPage

  mount_uploaders :uploads, UploadUploader

  belongs_to :user

  validates :name, :state, presence: true

  state_machine initial: :new do
    event :to_started do
      transition :new => :started
    end

    event :to_finished do
      transition :started => :finished
    end
  end

  scope :search, -> q {
    where = 'CAST(tasks.id AS TEXT) LIKE (:q) OR ' +
      'lower(name) LIKE lower(:q) OR ' +
      'lower(description) LIKE lower(:q) OR ' +
      'lower(state) LIKE lower(:q) OR ' +
      'lower(users.email) LIKE lower(:q)'
    joins(:user).where(where, q: "%#{q}%")
  }

  scope :by_state, -> state {
    with_state(state) if state != 'all'
  }

  def self.as_json_include
    { include: { user: { only: [:email] } } }
  end
end

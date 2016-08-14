module IndexPage
  extend ActiveSupport::Concern

  included do
    scope :index, -> { order(id: :desc) }
  end
end

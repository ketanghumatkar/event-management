class Enrollment < ApplicationRecord
  attribute :rsvp, :string, default: 'no'

  belongs_to :user
  belongs_to :event

  validates :rsvp, inclusion: { in: %w(yes no maybe) }

end

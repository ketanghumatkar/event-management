class Event < ApplicationRecord
  attribute :title, :string
  attribute :start_time, :datetime
  attribute :end_time, :datetime
  attribute :description, :text
  attribute :all_day, :boolean, default: false

  validates :title, presence: true
  validates :start_time, presence: true

  belongs_to :creator, class_name: "User"
  has_many :enrollments
  has_many :users, through: :enrollments, dependent: :destroy
end

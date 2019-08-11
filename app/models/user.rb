class User < ApplicationRecord
  attribute :username, :string
  attribute :email, :string
  attribute :phone, :string

  validates :username, presence: true
  validates :email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :phone, presence: true

  has_many :enrollments
  has_many :events, through: :enrollments, dependent: :destroy
end

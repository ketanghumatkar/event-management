class Enrollment < ApplicationRecord
  attribute :rsvp, :string, default: 'no'


  belongs_to :user
  belongs_to :event

  validates :rsvp, inclusion: { in: %w(yes no maybe) }

  before_save :validate_or_change_rsvp, if: -> { rsvp == 'yes' }

  def validate_or_change_rsvp
    Enrollment.where(
        user_id: self.user_id,
        event_id: overlapping_enrollments.map(&:id)
      )
      .update_all(rsvp: false)
  end

  private

  def overlapping_enrollments
    Enrollment.joins(:event)
      .select('distinct enrollments.*, events.start_time as start_time, events.end_time as end_time, events.all_day as all_day')
      .where("start_time >= ? AND end_time <= ?", self.event.start_time, self.event.end_time)
  end
end

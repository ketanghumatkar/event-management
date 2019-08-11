class EventsController < ApplicationController

  def index
    @events = Event.where('start_time >= ? AND end_time <= ?', permitted_params.start_time, permitted_params.end_time)
  end

  private

  def permitted_params
    params.permit(:start_time, :end_time)
  end
end

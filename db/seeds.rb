# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
# [{ username: 'Ketan', email: 'ketan@yy.com', phone: '23456' }, { username: 'Jonny', email: 'jonny@yy.com', phone: '23456' }].each do |u|
#   user = User.new(u)
#   user.save!
#   puts "."
# end
# ([
#   { creator_id: User.first.id , title: 'Ruby meetup', description: "Awesome event", start_time: Date.new(2001,2,3), end_time: Date.new(2001,2,5), all_day: false },
#   { creator_id: User.second.id , title: 'Python meetup', description: "Lovely event", start_time: Date.new(2012,1,5), end_time: Date.new(2012,1,7), all_day: false },
#   { creator_id: User.second.id , title: 'Painting Competition', start_time: Date.new(2012,1,5), all_day: true }
# ]).each do |e|
#   event = Event.new(e)
#   event.save!
#   puts "."
# end

# User.all.each do |user|
#   Event.all.each do |event|
#     en = Enrollment.new({user_id: user.id, event_id: event.id, rsvp: 'no'})
#     puts ">>"
#   end
# end

# Enrollment.create({user_id: User.all.first.id, event_id: Event.second.id, rsvp: 'yes'})
# Enrollment.create({user_id: User.all.first.id, event_id: Event.third.id, rsvp: 'yes'})

# Upload using files

require 'csv'
require 'fileutils'
require_relative './csv_split'

####
#
#  Seeding users
#
####
USER_SEED_PATH = Rails.root.to_s + '/db/users.csv'
SPLIT_PATH = Rails.root.to_s + '/db/split_files'

# Divide large data csv in multiple smaller onces
CsvSplit.split(USER_SEED_PATH)

# Load each splited csv in database
Dir.glob("#{SPLIT_PATH}/*.csv") do |csv_name|

  CSV.foreach(csv_name, headers: true) do |row|
    u = User.new
    u.username = row['username']
    u.email = row['email']
    u.phone = row['phone']

    u.save!
  end
end

CsvSplit.flush_dir(SPLIT_PATH)






####
#
#  Seeding events and enrollments
#
####

EVENT_SEED_PATH = Rails.root.to_s + '/db/events.csv'
creator = User.first

# Divide large data csv in multiple smaller onces
CsvSplit.split(EVENT_SEED_PATH)

# Load each splited csv in database
Dir.glob("#{SPLIT_PATH}/*.csv") do |csv_name|

  CSV.foreach(EVENT_SEED_PATH, headers: true) do |row|
    e = Event.new
    e.title = row['title']
    e.start_time = DateTime.parse(row['starttime'])
    e.end_time = DateTime.parse(row['endtime'])
    e.description = row['description']
    e.all_day = row['allday'] == 'true' ? true : false
    e.creator =  creator

    e.save!

    # Seeding enrollments

    ## TODO
    # Refactor - move to EnrollSeed class
    raw_data = row['users#rsvp']
    next if raw_data.blank?

    user_and_status = raw_data.split(';')
    uers = user_and_status.map do |raw_us|
      us = raw_us.split('#')
      { username: us.first, rsvp: us.second }
    end

    uers.each do |uer|
      ur = User.find_by(username: uer[:username])

      en = Enrollment.new
      en.user = ur
      en.event = e
      en.rsvp = uer[:rsvp]
      en.save!
    end

  end
end

CsvSplit.flush_dir(SPLIT_PATH)

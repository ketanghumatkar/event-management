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

# namespace :user do
#   desc "Send weekly emmail with info"
#   task send_weekly_email: :environment do
#     User.find_each do |user|
#       UserMailer.whith(user: user).weekly_email.deliver_later
#     end
#   end

# end

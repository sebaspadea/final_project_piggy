class SendMailJob < ApplicationJob
  queue_as :default
  after_perform do
    self.class.set(wait_until: date_of_next("Friday")).perform_later
  end

  def perform()
    User.find_each do |user|
    UserMailer.with(user_id: user.id).weekly_email.deliver_later
    end
  end

  def date_of_next(day)
  date  = Date.parse(day)
  delta = date > Date.today ? 0 : 7
  (date + delta).to_time
  end


end

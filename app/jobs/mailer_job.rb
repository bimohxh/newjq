class MailerJob < ActiveJob::Base
  queue_as :email

  def perform item
    AdminMailer.mem(item).deliver_now
  end
end

class ApplicationMailer < ActionMailer::Base
  default from: ENV["EMAIL_SENDER"] || 'from@example.com'
  default replyTo: ENV["EMAIL_SENDER"]
  layout 'mailer'
end

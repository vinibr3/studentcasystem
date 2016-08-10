class ApplicationMailer < ActionMailer::Base
  default from: ENV["STUDENTCASYSTEM_EMAIL_USER"]
  layout 'mailer'
end

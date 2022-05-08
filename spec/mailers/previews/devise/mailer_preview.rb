class Devise::MailerPreview < ActionMailer::Preview
    def reset_password_instructions
      Devise::Mailer.reset_password_instructions(User.first, {})
    end

    def email_changed
      Devise::Mailer.email_changed(User.last, {})
    end
  end
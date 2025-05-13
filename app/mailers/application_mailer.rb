class ApplicationMailer < ActionMailer::Base
  default from: "adam@naamani.ca"
  default template_path: "mailers"
  layout "mailer"
end

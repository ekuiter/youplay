ActionMailer::Base.raise_delivery_errors = true

ActionMailer::Base.smtp_settings = {
  :address        => 'smtp.sendgrid.net',
  :port           => '587',
  :authentication => :plain,
  :user_name      => Settings.SENDGRID_USERNAME,
  :password       => Settings.SENDGRID_PASSWORD,
  :domain         => 'heroku.com',
  :enable_starttls_auto => true
}
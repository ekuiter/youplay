class YouplayMailer < ActionMailer::Base
  default from: "\"youplay\" <donotreply@#{Settings.root}>"
  
  def share(user, video, person, message)
    @user, @video, @person, @message = user, video, person, message
    mail to: @person.email, subject: "#{@user.full_name} #{t("player.share_mail.subject")} \"#{@video.title}\"", reply_to: @user.email
  end
end
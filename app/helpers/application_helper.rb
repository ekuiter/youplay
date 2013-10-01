module ApplicationHelper

  def title(title, options = {})
    @title = content = title
    if options[:link]
      content = link_to title, options[:link], target: options[:target]
    end
    str = "<h1 onmouseover=\"#{options[:onmouseover]}\" onmouseout=\"#{options[:onmouseout]}\">
    #{content}#{options[:additional_content]}
      <span class=\"module_description\">
        #{t "modules.#{@module+''}_description", application_name: t('application.name') if @module}
      </span>
    </h1>"
    @page_title = str.html_safe
    nil
  end

  def generate_title
    "#{@title ? "#@title | " : ''}#{t 'application.name'}"
  end

  def modules
    {
        t('modules.player') => player_path,
        t('modules.log') => log_path,
        t('modules.stats') => stats_path,
        t('modules.conf') => conf_path,
        t('modules.reader') => reader_path
    }
  end

  def set_focus_to(id)
    javascript_tag "$('##{id}').focus()"
  end

  def js_redirect_to(options)
    return javascript_tag "window.setTimeout(\"window.location.href = '#{options[:url]}'\", #{options[:delay]})" if options[:delay].present?
    javascript_tag "window.location.href = '#{options[:url]}'"
  end

  def error_messages!(resource)
    return '' if resource.errors.empty?

    messages = resource.errors.full_messages.map { |msg| content_tag(:li, msg) }.join
    sentence = I18n.t('errors.messages.not_saved',
                      :count => resource.errors.count,
                      :resource => resource.class.model_name.human.downcase)

    html = <<-HTML
    <div id="error_explanation">
      <h4>#{sentence}</ h4>
    <ul> #{messages}</ul>
    </div>
    HTML

    html.html_safe
  end

  include HttpRequest
  include YoutubeConnector

  def channel_link profile
    begin
      profile = fetch_profile profile
      link_to profile.username_display, profile.url, target: :_blank
    rescue
      profile
    end
  end
  
  def fetch_profile profile
    @client = youtube_client if @client.nil? && profile.is_a?(String)
    return @client.profile(profile.gsub('http://gdata.youtube.com/feeds/api/users/', '')) if profile.is_a? String
    profile
  end

  def video_duration(video)
    return nil unless video.duration
    duration = video.duration / 60
    "#{duration} #{t 'player.meta.minutes', count: duration}"
  end
  
  def void
    "javascript:void(0)"
  end
  
  class YouTubeIt::Model::User
  
    def url
      "http://www.youtube.com/channel/UC#{user_id}"
    end
  
  end

end

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

  def link_to_channel(channel)
    url = channel
    begin
      if channel.include? ' '
        req = http_request url: 'https://gdata.youtube.com/feeds/api/channels?v=2&q=' + channel.gsub(' ', '+')
        url = req.body.split("<author><name>#{channel}</name><uri>https://gdata.youtube.com/feeds/api/users/")[1].split('</uri>')[0]
      end
      link_to channel, "http://youtube.com/user/#{url}", target: '_blank'
    rescue
      channel
    end
  end

  def video_duration(video)
    return nil unless video.duration
    duration = video.duration / 60
    "#{duration} #{t 'player.meta.minutes', count: duration}"
  end
  
  def void
    "javascript:void(0)"
  end

end

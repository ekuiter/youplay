module ApplicationHelper
  def title(title, options = {})
    @title = content = title
    if options[:link]
      content = link_to title, options[:link], target: options[:target]
    end
    @page_title = render "/page_title", content: content, options: options
    nil
  end

  def generate_title
    "#{@title ? "#@title | " : ''}#{t 'application.name'}"
  end

  def set_focus_to(id)
    javascript_tag "$('##{id}').focus()"
  end

  def nav_link_to(body, url, html_options = {})
    html_options.merge! class: "active" if @current_path == url
    link_to body, url, html_options
  end
  
  def maybe_link_to(body, url, create_link, html_options = {})
    if create_link
      link_to body, url, html_options
    else
      body
    end
  end
  
  def error_messages!(resource)
    return '' if resource.errors.empty?

    messages = resource.errors.full_messages.map { |msg| content_tag(:li, msg) }.join
    sentence = I18n.t('errors.messages.not_saved',
                      :count => resource.errors.count,
                      :resource => resource.class.model_name.human.downcase)

    html = <<-HTML
    <div id="error_explanation">
      <h4>#{sentence}</h4>
    <ul> #{messages}</ul>
    </div>
    HTML

    html.html_safe
  end
  
  def void
    "javascript:void(0)"
  end
  
  def ajax_channel(provider, channel, tag)
    "<#{tag} class=\"ajax-user\" data-user=\"#{provider}:#{channel}\">#{image_tag "loading-small.gif"}</#{tag}>".html_safe
  end
  
  def user_browser
    user_agent = request.env['HTTP_USER_AGENT'].downcase
    begin
      if user_agent.index('msie') && !user_agent.index('opera') && !user_agent.index('webtv')
        return 'Internet Explorer'
      elsif user_agent.index('gecko/')
        return 'Gecko'
      elsif user_agent.index('opera')
        return 'Opera'
      elsif user_agent.index('konqueror')
        return 'Konqueror'
      elsif user_agent.index('ipod')
        return 'iPod'
      elsif user_agent.index('ipad')
        return 'iPad'
      elsif user_agent.index('iphone')
        return 'iPhone'
      elsif user_agent.index('chrome/')
        return 'Chrome'
      elsif user_agent.index('applewebkit/')
        return 'Safari'
      elsif user_agent.index('googlebot/')
        return 'Google Bot'
      elsif user_agent.index('msnbot')
        return 'MSN Bot'
      elsif user_agent.index('yahoo! slurp')
        return 'Yahoo Bot'
      #Everything thinks it's mozilla, so this goes last
      elsif user_agent.index('mozilla/')
        return 'Gecko'
      else
        return 'Unknown'
      end
    end
  end
end

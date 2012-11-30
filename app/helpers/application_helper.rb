module ApplicationHelper

  def title title, options = {}
    @title = title
    return "<h2 class=\"title\">#{link_to title, options[:link], target: :blank}</h2>".html_safe if options[:link]
    return "<h2 class=\"title\">#{title}</h2>".html_safe
  end

  def generate_title
    "#{@title ? "#{@title} | " : ""}#{t "application.name"}"
  end

  def modules
    {
        t("modules.player") => player_path,
        t("modules.log") => log_path,
        t("modules.stats") => stats_path,
        t("modules.conf") => conf_path,
        t("modules.reader") => reader_path
    }
  end

  def set_focus_to id
    javascript_tag "$('##{id}').focus()"
  end

  def js_redirect_to options
    return javascript_tag "window.setTimeout(\"window.location.href = '#{options[:url]}'\", #{options[:delay]})" if options[:delay].present?
    return javascript_tag "window.location.href = '#{options[:url]}'"
  end

  def error_messages! resource
    return "" if resource.errors.empty?

    messages = resource.errors.full_messages.map { |msg| content_tag(:li, msg) }.join
    sentence = I18n.t("errors.messages.not_saved",
                      :count => resource.errors.count,
                      :resource => resource.class.model_name.human.downcase)

    html = <<-HTML
    <div id="error_explanation">
      <h4>#{sentence}</h4>
      <ul>#{messages}</ul>
    </div>
    HTML

    html.html_safe
  end

end

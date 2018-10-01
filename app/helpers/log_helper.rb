module LogHelper
  def js_redirect(url)
    "window.location.href = ('#{escape_javascript(url)}')"
  end
  
  def button_to_page(title, page)
    button_tag title, onclick: js_redirect(log_path(page, @results, search: @search))
  end

  def pages
    pages = pages_list @current_page
    if pages.blank?
      pages_list 1
    else
      pages
    end
  end

  def pages_list(current_page)
    range = 6
    pages = []
    (current_page-range..current_page+range).each do |page|
      if (1..@page_count).include? page
        if page == current_page
          pages << button_tag(page.to_s, class: :active)
        else
          pages << button_tag(page, onclick: js_redirect(log_path(page, @results, search: @search)))
        end
      end
    end
    pages
  end

  def results
    results = []
    (1..(@results_range.max / @results_range.min)).each do |this|
      result_number = @results_range.min*this
      if result_number == @results
        results << button_tag(result_number, class: :active)
      else
        results << button_tag(result_number, onclick: js_redirect(log_path(@current_page, result_number, search: @search)))
      end
    end
    results
  end

  def search_path(type, search = nil, module_path = log_path)
    path = "#{module_path}?search=#{type}"
    path += ":#{search}" if search
    path
  end
end

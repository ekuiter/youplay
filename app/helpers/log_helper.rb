module LogHelper  
  def link_to_page(title, page)
    link_to title, log_path(page, @results, search: @search)
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
          pages << page.to_s
        else
          pages << link_to(page, log_path(page, @results, search: @search))
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
        results << result_number.to_s
      else
        results << link_to(result_number, log_path(@current_page, result_number, search: @search))
      end
    end
    results
  end
end

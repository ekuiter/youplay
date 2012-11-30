module Log::LogHelper

  def first_page
    link_to t("video_list.first"), log_path(1, @results)
  end

  def previous_page
    link_to t("video_list.previous"), log_path(@current_page - 1, @results)
  end

  def next_page
    link_to t("video_list.next"), log_path(@current_page + 1, @results)
  end

  def last_page
    link_to t("video_list.last"), log_path(@page_count, @results)
  end

  def pages
    pages = pages_list @current_page
    return pages unless pages == []
    return pages_list 1
  end

  def pages_list current_page
    range = 6
    pages = []
    (current_page-range..current_page+range).each do |page|
      if (1..@page_count).include? page
        if page == current_page
          pages << page.to_s
        else
          pages << link_to(page, log_path(page, @results))
        end
      end
    end
    return pages
  end

  def results
    results = []
    (1..(@results_range.max / @results_range.min)).each do |this|
      result_number = @results_range.min*this
      if result_number == @results
        results << result_number.to_s
      else
        results << link_to(result_number, log_path(@current_page, result_number))
      end
    end
    return results
  end

end

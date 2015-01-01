class Api::StatsController < Api::AuthenticatedController
  include ControllerMixins::StatsController
  include Series
  before_filter :reset_color
  before_filter :invalid_search
  alias :helper :view_context

  def browsers_doughnut
    render json: doughnut(collection, :browser, &helper.browsers_labels)
  end

  def browsers_line
    render json: line(collection, :browser, &helper.browsers_labels(true))
  end

  def providers_doughnut
    data = doughnut collection, :provider, Proc.new { |data|
      StatsColors.next_color if data.length > 1
      data
    }, &helper.providers_labels
    render json: data
  end

  def providers_line
    data = line collection, :provider, &helper.providers_labels(true)
    if data[:datasets].length > 1
      all_videos = []
      data[:datasets].each do |dataset|
        dataset[:data].each_with_index do |record, index|
          all_videos[index] = (all_videos[index] || 0) + record
        end
      end
      helper.add_line_dataset_at_beginning! data, helper.link_to(I18n.t("video_list.all_videos"), stats_path), all_videos
      helper.line_data_generate_colors!(data)
    end
    render json: data
  end

  def categories_doughnut
    render json: doughnut(collection, :category_id, &helper.categories_labels)
  end

  def categories_line
    render json: line(collection, :category_id, &helper.categories_labels(true))
  end
  
  def channels_doughnut
    render json: doughnut(collection, helper.channel_column,
                          helper.limit_data, &helper.channels_labels)
  end

  def channels_line
    render json: line(collection, helper.channel_column, &helper.channels_labels(true))
  end

  def series_doughnut
    render json: find_series(collection, :title, &make_series_doughnut)
  end

  def series_line
    render json: find_series(collection, :title, &make_series_line)
  end

  private

  def reset_color
    StatsColors.reset
  end

  def invalid_search
    render nothing: true if not collection or @search_type == :invalid    
  end

  def doughnut(collection, column, adjust_data = nil)
    column_data = collection.group(column).count
    data = column_data.map do |record, count|
      { label: record, value: count }
    end
    data.sort_by! {|record| -record[:value]}
    data = adjust_data.call(data) if adjust_data
    if block_given?
      data.each do |record|
        record[:label] = yield(record[:label])
      end
    end
    data.generate_colors!
    data
  end

  def line(collection, column, adjust_data = nil)
    column_data = collection.group(column).order("videos.created_at").
      group(helper.month_column).count
    months = helper.months_by_column_data(column_data)
    datasets = {}
    column_data.each do |key, value|
      record, month = key
      datasets[record] ||= Hash[months.map {|month| [month, 0]}]
      datasets[record][month] += value
    end
    data = { labels: helper.humanize_months(months), datasets: [] }
    datasets.each do |record, record_data|
      helper.add_line_dataset! data, record, record_data.values
    end
    data[:datasets] = data[:datasets].sort_by {|dataset| -dataset[:data].sum}[0..7]
    helper.line_data_generate_colors!(data)
    data = adjust_data.call(data) if adjust_data
    if block_given?
      data[:datasets].each do |dataset|
        dataset[:label] = yield(dataset[:label])
      end
    end
    data
  end
end


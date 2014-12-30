class Api::StatsController < Api::AuthenticatedController
  include ControllerMixins::StatsController
  before_filter :reset_color
  before_filter :invalid_search
  alias :helper :view_context

  def browsers_doughnut
    render json: doughnut(collection, :browser)
  end

  def browsers_line
    render json: line(collection, :browser)
  end

  def providers_doughnut
    data = doughnut collection, :provider, &helper.providers_labels
    render json: data
  end

  def providers_line
    data = line collection, :provider, &helper.providers_labels
    if data[:datasets].length > 1
      all_videos = []
      data[:datasets].each do |dataset|
        dataset[:data].each_with_index do |record, index|
          all_videos[index] = (all_videos[index] || 0) + record
        end
      end
      helper.add_line_dataset_at_beginning! data, I18n.t("video_list.all_videos"), all_videos
    end
    render json: data
  end

  def categories_doughnut
    data = doughnut collection, :category_id, &helper.categories_labels
    render json: data
  end

  def categories_line
    data = line collection, :category_id, &helper.categories_labels
    render json: data
  end
  
  def channels_doughnut
    video_count = current_user.videos.count
    data = doughnut collection, helper.channel_column, Proc.new { |data|
      data.sort_by! {|record| -record[:value] }.select! {|record| record[:value] > video_count / 100}
    }, &helper.channels_labels
    render json: data
  end

  def channels_line
    video_count = current_user.videos.count
    data = line collection, helper.channel_column, Proc.new { |data|
      data[:datasets] = data[:datasets].sort_by! {|dataset| -dataset[:data].sum}[0..7]
      helper.line_data_generate_colors!(data)
    }, &helper.channels_labels
    render json: data
  end

  private

  def reset_color
    StatsColors.reset
  end

  def invalid_search
    render nothing: true if not collection or @search_type == :invalid    
  end

  def doughnut(collection, column, adjust_data = nil)
    column_data = collection.pluck(column)
    data = column_data.uniq.map do |record|
      { label: record, value: column_data.count(record) }
    end
    adjust_data.call(data) if adjust_data
    if block_given?
      data.each do |record|
        record[:label] = yield(record[:label])
      end
    end
    data.generate_colors!
    data
  end

  def line(collection, column, adjust_data = nil)
    column_data_and_timestamps, column_data, timestamps = helper.pluck_multiple(collection, [column, "videos.created_at"]) do |result|
      result.each do |record|
        record[:created_at] = record[:created_at].to_date.change(day: 1)
      end
    end
    column_data = column_data.uniq
    months = helper.months_by_timestamps(timestamps)    
    data = { labels: helper.humanize_months(months), datasets: [] }    
    column_data.each do |record|
      record_and_timestamps = column_data_and_timestamps.select {|b| b[column] == record}
      timestamps = helper.extract_column(record_and_timestamps, :created_at)
      helper.add_line_dataset! data, record, months.map {|m| timestamps.count(m) }
    end
    adjust_data.call(data) if adjust_data
    if block_given?
      data[:datasets].each do |dataset|
        dataset[:label] = yield(dataset[:label])
      end
    end
    data
  end
end


class Api::StatsController < Api::AuthenticatedController
  include ControllerMixins::StatsController
  before_filter :reset_color
  alias :helper :view_context

  def browsers_doughnut
    render json: doughnut(collection, :browser)
  end

  def browsers_line
    render json: line(collection, :browser)
  end

  def providers_doughnut
    data = doughnut collection, :provider, &helper.provider_labels
    render json: data
  end

  def providers_line
    data = line collection, :provider, &helper.provider_labels
    all_videos = []
    data[:datasets].each do |dataset|
      dataset[:data].each_with_index do |record, index|
        all_videos[index] = (all_videos[index] || 0) + record
      end
    end
    helper.add_line_dataset_at_beginning! data, I18n.t("stats.all_videos"), all_videos
    render json: data
  end

  private

  def reset_color
    StatsColors.reset
  end

  def doughnut(collection, column)
    column_data = collection.pluck(column)
    data = column_data.uniq.map do |record|
      { label: block_given? ? yield(record) : record, value: column_data.count(record) }
    end
    data.generate_colors!
    data
  end

  def line(collection, column)
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
      helper.add_line_dataset! data,
        block_given? ? yield(record) : record,
        months.map {|m| timestamps.count(m) }
    end
    data
  end
end


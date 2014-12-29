class Api::StatsController < Api::AuthenticatedController
  before_filter :reset_color
  alias :helper :view_context

  def browsers_doughnut
    collection = current_user.videos
    render json: doughnut(collection, :browser)
  end

  def browsers_line
    collection = current_user.videos
    render json: line(collection, :browser)
  end

  def providers_doughnut
    collection = current_user.videos
    render json: doughnut(collection, :provider)
  end

  def providers_line
    collection = current_user.videos
    render json: line(collection, :provider)
  end

  private

  def reset_color
    StatsColors.reset
  end

  def doughnut(collection, column)
    column_data = collection.pluck(column)
    data = column_data.uniq.map {|record| { label: record, value: column_data.count(record) }}
    data.generate_colors!
    data
  end

  def line(collection, column)
    column_data_and_timestamps, column_data, timestamps = helper.pluck_multiple(collection, [column, :created_at]) do |result|
      result.each do |record|
        record[:created_at] = record[:created_at].to_date.change(day: 1)
      end
    end
    column_data = column_data.uniq
    months = helper.months_by_timestamps(timestamps)    
    data = { labels: helper.humanize_months(months), datasets: [] }    
    column_data.each do |record|
      StatsColors.next_color
      record_and_timestamps = column_data_and_timestamps.select {|b| b[column] == record}
      timestamps = helper.extract_column(record_and_timestamps, :created_at)
      data[:datasets].push label: record,
        fillColor: StatsColors.color(0.5),
        strokeColor: StatsColors.color,
        pointColor: StatsColors.color,
        data: months.map {|m| timestamps.count(m) }
    end
    data
  end
end


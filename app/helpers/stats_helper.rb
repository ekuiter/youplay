module StatsHelper
  def months_by_column_data(column_data)
    data_months = column_data.map do |key, value|
      record, month = key
      month
    end.uniq.sort
    months = []
    month = data_months.first
    while month <= data_months.last
      months.push month
      month = month.next_month
    end
    months
  end

  def humanize_months(months)
    months.map do |month|
      l(month, format: :month)
    end
  end

  def pluck_multiple(collection, columns)
    query = collection.select(columns)
    result = ActiveRecord::Base.connection.select_all(query)
    result.map! {|record| record.symbolize_keys}
    yield(result) if block_given?
    ret = [result]
    columns.each do |column|
      column = column.split(".").last.to_sym if column.is_a?(String)
      ret.push(extract_column(result, column))
    end
    ret
  end

  def extract_column(result, column)
    result.map {|record| record[column]}
  end

  def providers_labels
    Proc.new do |record|
      YouplayProvider.new(provider: record).name
    end
  end

  def categories_labels
    Proc.new do |record|
      categories = current_user.categories.all
      if record.blank?
        t "stats.no_category"
      else
        category = categories.select {|c| c.id == record}.first
        category ? category.name : record
      end
    end
  end
  
  def channels_labels
    Proc.new do |record|
      provider, id = record.split(":")
      begin
        YouplayChannel.new(provider: YouplayProvider.new(provider: provider), id: id).name
      rescue
        id
      end
    end
  end

  def channel_column
    "concat(provider, ':', channel_topic)"
  end

  def add_line_dataset!(data, label, dataset)
    StatsColors.next_color
    data[:datasets].push label: label,
      fillColor: StatsColors.color(0.4),
      strokeColor: StatsColors.color,
      pointColor: StatsColors.color,
      data: dataset
  end

  def line_data_generate_colors!(data, opacity)
    StatsColors.reset
    data[:datasets].each do |dataset|
      StatsColors.next_color
      dataset[:fillColor] = StatsColors.color(opacity)
      dataset[:strokeColor] = dataset[:pointColor] = StatsColors.color
    end
  end

  def add_line_dataset_at_beginning!(data, label, dataset)
    old_datasets = data[:datasets]
    data[:datasets] = []
    add_line_dataset!(data, label, dataset)
    data[:datasets].push *old_datasets
  end
end

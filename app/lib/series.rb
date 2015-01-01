module Series
  private
  
  def group_parts(record, next_record)
    return nil if record.blank? or next_record.blank?
    record_parts, next_record_parts = record.split, next_record.split
    group_parts = []
    found_parts = false
    record_parts.each_with_index do |record_part, idx|
      if record_part == next_record_parts[idx]
        found_parts = true
        group_parts.push record_part
      elsif found_parts
        break 
      end
    end
    group_parts
  end

  def adjust_group(group_parts)
    group = group_parts.join(" ")
    group = group.blank? ? "" : group
    ["part", "teil", "folge", "episode"].each do |pattern| 
      group.gsub!(/#{pattern}([^\w]|$)/i, "")
    end
    group = group.strip[0..-2] if ["-", "["].include?(group.strip[-1])      
    group.strip 
  end

  def episode_number(record)
    match = record.gsub(/&#\d+;/, "").match(/\d+/)
    match.blank? ? nil : match[0].to_i
  end

  def find_series(collection, column)
    column_data = collection.pluck(column)
    column_data.sort!
    i = 0
    series = column_data.group_by do |record|
      next_record = column_data[i += 1]
      group_parts(record, next_record)
    end
    series = series.select do |group_parts, column_data|
      column_data.map! do |record|
        { title: record, episode: episode_number(record) }
      end
      column_data.length > 1 and not column_data.map {|record| record[:episode]}.include?(nil)
    end
    series.keys.each do |group_parts|
      series[adjust_group(group_parts)] = series[group_parts]
      series.delete(group_parts)
    end
    if block_given?
      series_array = series.map do |group, column_data|
        { label: group, value: column_data.length }
      end
      series_array.sort_by! {|series| -series[:value]}
      yield(series_array, column)
    else
      series.each do |group, column_data|
        column_data.sort_by! {|record| record[:episode]}
      end
      series_array = series.map do |group, column_data|
        { group: group, videos: column_data }
      end
      series_array.sort_by! do |series|
        -series[:episodes] = series[:videos].length
      end
      series_array
    end
  end

  def make_series_doughnut
    Proc.new do |series_array, column|
      data = helper.limit_data.call(series_array)
      data.push({ label: t("stats.no_series_found"), value: 1 }) if data.blank?
      data.generate_colors!
      data
    end
  end

  def make_series_line
    Proc.new do |series_array, column|
      series_array = series_array[0..7]
      match_series = "^(#{series_array.map {|series| series[:label]}.join("|")})"
      months = collection.where("#{column} regexp ?", match_series).pluck(helper.month_column).uniq
      data = { labels: helper.humanize_months(months), datasets: [] }
      series_array.map do |series|
        dataset ||= Hash[months.map {|month| [month, 0]}]
        series_months = collection.where("#{column} like ?", "#{series[:label]}%").pluck(helper.month_column)
        series_months.each {|month| dataset[month] += 1}
        helper.add_line_dataset!(data, series[:label], dataset.values)
      end
      helper.line_data_generate_colors!(data)
      data
    end
  end
end

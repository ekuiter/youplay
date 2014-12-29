module StatsHelper
  def months_by_timestamps(timestamps)
    months = []
    month = timestamps.uniq.sort.first
    while month <= Date.today.at_beginning_of_month
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
      ret.push(extract_column(result, column))
    end
    ret
  end

  def extract_column(result, column)
    result.map {|record| record[column]}
  end
end

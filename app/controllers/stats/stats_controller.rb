class Stats::StatsController < ApplicationController
  include ControllerMixins::StatsController

  def index
    @watched_videos = collection.count
    @start_date = collection.first.created_at
    @end_date = collection.last.created_at

    durations = collection.pluck(:duration).select {|d| not d.nil?}
    duration_total = durations.sum
    minutes_total = duration_total.to_f / 60
    @days = (minutes_total / (60 * 24)).to_i
    @hours = (minutes_total % (60 * 24) / 60).to_i
    @minutes = (minutes_total % 60).to_i
    
    @birthday = current_user.birthday ? current_user.birthday.to_time : nil
    @percent = duration_total / (Date.today.to_time - @birthday) * 100

    duration_stats = DescriptiveStatistics::Stats.new(durations)
    @duration_average = duration_stats.mean / 60
    @duration_deviation = duration_stats.standard_deviation / 60
  end
end

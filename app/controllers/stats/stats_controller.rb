class Stats::StatsController < ApplicationController
  include ControllerMixins::StatsController
  alias :helper :view_context

  def index
    @providers, @browsers = helper.pluck_multiple(current_user.videos, [:provider, :browser])[1..-1].map(&:uniq)
    @categories = current_user.categories

    unless collection.blank?
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
      @percent_lifetime = duration_total / (Date.today.to_time - @birthday) * 100
      @percent_time_frame = duration_total / (@end_date.to_time - @start_date.to_time) * 100

      duration_stats = DescriptiveStatistics::Stats.new(durations)
      @duration_average = duration_stats.mean / 60
      std_dev = duration_stats.standard_deviation
      @duration_deviation = std_dev.nil? ? 0 : std_dev / 60
      #collection.pluck(:title).group_by {|t| t[/\w+/]}
    end

    # def group(arr)
    #   hash = arr.group_by {|e| e[/\S+(\s\S+){#{@stack}}/]}
    #   hash_series = hash.select {|k,v| v.length > 1}
    #   new_hash = {}
    #   @stack += 1
    #   hash_series.each do |key, arr|
    #     unless (tmp = group(arr)).blank?
    #       new_hash[key] = tmp
    #     end
    #   end if @stack < 3
    #   @stack -= 1
    #   new_hash.blank? ? hash_series : new_hash
    # end

  end
end

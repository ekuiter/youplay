module ControllerMixins
  module StatsController
    include LogAndStatsController
    
    private
    
    def collection
      @collection, @search, @search_type = figure_collection(params[:search]) if @collection.nil?
      @collection
    end
  end
end


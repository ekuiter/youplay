class Conf::CategoriesController < ApplicationController
  before_filter :set_category, only: [:edit, :update, :destroy]
  
  def index
    @categories = current_user.categories
  end

  def new
    @category = current_user.categories.new
  end

  def edit
  end

  def create
    @category = current_user.categories.new params[:category]
    if @category.save
      redirect_to conf_categories_path, notice: t('conf.categories.create.success', category: @category.name)
    else
      render 'new'
    end
  end

  def update
    @category.name = params[:category][:name]
    if @category.save
      redirect_to conf_categories_url, notice: t('conf.categories.update.success', category: @category.name)
    else
      render 'edit'
    end
  end

  def destroy
    @category.destroy
    redirect_to conf_categories_url, notice: t('conf.categories.destroy', category: @category.name)
  end

  def quick
    relevant_channel = 10
    @channel_number = 40
    YouplayChannel.prefetch_all
    @categories = current_user.categories
    uncategorized_videos = current_user.videos.where(category_id: nil, provider: :youtube).
        group(:channel_topic).count.sort_by { |channel, count| -count }
    @uncategorized_channels = uncategorized_videos.
        select { |entry| entry.last > relevant_channel }[0..@channel_number-1].
        map do |entry|
          channel_name = begin
            YouplayChannel.new(id: entry.first, provider: YouplayProvider.youtube).name
          rescue
            entry.first
          end
          ["#{channel_name} (#{entry.last})", entry.first]
        end
  end

  def save_quick
    begin
      category_id = current_user.categories.find(params[:category]).id
      videos = current_user.videos.where(channel_topic: params[:channel])
      videos.update_all(category_id: category_id)
      redirect_to conf_quick_path
    rescue
      redirect_to conf_quick_path, alert: t('conf.categories.quick_fail')
    end
  end

  private
  
  def set_category
    @category = current_user.categories.find params[:id]
  end
end

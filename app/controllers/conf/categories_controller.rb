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
  
  private
  
  def set_category
    @category = current_user.categories.find params[:id]
  end
end

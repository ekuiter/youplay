class Conf::PeopleController < ApplicationController
  before_filter :set_person, only: [:edit, :update, :destroy]
  
  def index
    @people = current_user.people
  end

  def new
    @person = current_user.people.new
  end

  def edit
  end

  def create
    @person = current_user.people.new params[:person]
    if @person.save
      redirect_to conf_people_path, notice: t('conf.people.create.success', person: @person.name)
    else
      render 'new'
    end
  end

  def update
    @person.update_attributes name: params[:person][:name], email: params[:person][:email]
    if @person.save
      redirect_to conf_people_url, notice: t('conf.people.update.success', person: @person.name)
    else
      render 'edit'
    end
  end

  def destroy
    @person.destroy
    redirect_to conf_people_url, notice: t('conf.people.destroy', person: @person.name)
  end
  
  private
  
  def set_person
    @person = current_user.people.find params[:id]
  end
end

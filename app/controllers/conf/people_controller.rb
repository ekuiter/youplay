class Conf::PeopleController < ApplicationController

  def index
    @people = current_user.people
  end

  def new
    @person = current_user.people.new
  end

  def edit
    @person = current_user.people.find params[:id]
  end

  def create
    @person = current_user.people.new params[:person]
    if @person.save
      redirect_to conf_people_path, notice: t("conf.people.create.success", person: @person.name)
    else
      render "new"
    end
  end

  def update
    @person = current_user.people.find params[:id]
    @person.update_attributes params[:person]
    flash.now.notice = t "conf.people.update.success", person: @person.name
    render "edit"
  end

  def destroy
    @person = current_user.people.find params[:id]
    @person.destroy
    redirect_to conf_people_url, notice: t("conf.people.destroy", person: @person.name)
  end
end

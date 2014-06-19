class Reader::HidingRulesController < ApplicationController
  def index
    @hiding_rules = current_user.hiding_rules
  end
  
  def create  
    begin
      hiding_rule = current_user.hiding_rules.new
      hiding_rule.pattern = params[:pattern]
      unless params[:channel].blank?
        @client = Providers::youtube_client
        profile = @client.profile params[:channel]
        flash[:alert] = t 'reader.hiding_rules.failure' unless profile
        hiding_rule.channel = profile.user_id
      end
      if hiding_rule.save
        flash[:notice] = t 'reader.hiding_rules.success'
      else
        flash[:alert] = t 'reader.hiding_rules.failure'
      end
    rescue
      flash[:alert] = t 'reader.hiding_rules.failure'
    end
    redirect_to reader_hiding_rules_path
  end
  
  def destroy
    current_user.hiding_rules.find(params[:hiding_rule]).destroy
    redirect_to reader_hiding_rules_path
  end
end

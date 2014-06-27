class Reader::HidingRulesController < ApplicationController
  def index
    @hiding_rules = current_user.hiding_rules
  end
  
  def create  
    begin
      hiding_rule = current_user.hiding_rules.new
      hiding_rule.pattern = params[:pattern]
      unless params[:channel].blank?
        channel = YouplayChannel.new(name: params[:channel], provider: YouplayProvider.youtube)
        hiding_rule.channel = channel.id
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

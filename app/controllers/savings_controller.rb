class SavingsController < ApplicationController

  def index
    @savings = Saving.all
  end

  def new
    @saving = Saving.new
  end

  def create
    @saving = Saving.new(saving_params)
    @saving.user = current_user
    @saving.status = "Open"
    @saving.total_amount = 0
    if @saving.save!
      redirect_to expenses_new_path
    else
      render :new
    end
  end
  
  private

  def saving_params
    params.require(:saving).permit(:goal, :goal_description)
  end

end

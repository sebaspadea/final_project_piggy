class SavingsController < ApplicationController
  before_action :set_saving, only: [:index, :edit, :update, :break_chanchito]

  def index
    @savings = current_user.savings
  end

  def new
    @saving = Saving.new
  end

  def edit
  end

  def update
    if @saving.update(saving_params)
      redirect_to savings_path
    else
      render 'edit'
    end
  end

  def break_chanchito
    @saving.update(status: "Broken")
    redirect_to user_path
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

  def set_saving
    @saving = current_user.savings.last
  end
end

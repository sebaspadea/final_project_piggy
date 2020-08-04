class ExpensesController < ApplicationController
  skip_before_action :authenticate_user!
  def index
    @expenses = Expense.all
  end


  def new
    @expence = Expense.new
  end

  def create
    @expense = Expense.find(params[:expense_id])
    if @expense.save!
      redirect_to user_path(current_user)
    else
      render :new
    end
  end


  private

   def expense_params
   params.require(:expense).permit(:category, :amount, :description)
  end

end

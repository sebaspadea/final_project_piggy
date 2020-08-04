class ExpensesController < ApplicationController
  skip_before_action :authenticate_user!
  def index
    @expenses = Expense.all
  end


  def new
    @expense = Expense.new

  end

  def create
    @expense = Expense.create(expense_params)
    @expense.user = current_user
    if @expense.save!
      redirect_to expenses_path
    else
      render :new
    end
  end


  private

   def expense_params
   params.require(:expense).permit(:category, :amount, :description)
  end

end

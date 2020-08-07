require "groupdate"

class ExpensesController < ApplicationController
  skip_before_action :authenticate_user!
  def index
    @expenses = current_user.expenses
  end

  def new
    @expense = Expense.new
  end

  def create
    @expense = Expense.new(expense_params)
    @expense.user = current_user
    @saving = current_user.savings.last
    @expense.saving = @saving
    if @expense.save
      @saving.total_amount += (@expense.amount * current_user.saving_percentage) / 100
      @saving.save
      if params[:test].nil?
        redirect_to expenses_path
        return
      else
        redirect_to expenses_new_path
      end
    else
      render :new
    end
  end

  def edit
    @expense = Expense.find(params[:id])
  end

  def update
    @expense = Expense.find(params[:id])

    if @expense.update(expense_params)
      redirect_to expenses_path
    else
      render 'edit'
    end
  end

  private

  def expense_params
    params.require(:expense).permit(:category, :amount, :description)
  end
end

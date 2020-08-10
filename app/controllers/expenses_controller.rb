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

    if params[:bank]
      p_client = PluggyClient.new
      items = p_client.fetch_items(0, { user: "user-ok", password: "password-ok" })
      # get th item id
      accounts = p_client.fetch_accounts(items["id"])
      # get the transaccions for the account
      transactions = p_client.fetch_transactions(accounts[0]["id"])
      # armo expenses con las transactions
      # transactions["results"] => array de hashes
      # usar p_client.transactions["results"].select { |t| ["Credit Card", "Transfer"].include?(t["category"])
      raise
      redirect_to expenses_path
    else
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
          flash[:success] = "Nuevo gasto agregado!"
          redirect_to expenses_new_path
        end
      else
        render :new
      end
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

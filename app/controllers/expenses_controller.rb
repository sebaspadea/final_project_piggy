require "groupdate"

class ExpensesController < ApplicationController
  include Pagy::Backend
  skip_before_action :authenticate_user!
  def index
    @pagy, @expenses = pagy(current_user.expenses)
  end

  def new
    if current_user.savings.empty? || current_user.savings.last.status != "Open"
      redirect_to new_saving_path
    else
      @expense = Expense.new
    end
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
        flash[:success] = "Nuevo gasto agregado!"
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

  # Hacer migracion y agregar pluggy_item_id:string, pluggy_last_update:date
  # En el new de expenses, lo vamos a mostrar solo si no tiene pluggy_item_id en el usuario
  # Si no tiene pluggy_item_id, vamos a hacer un nuevo metodo para recibir la data del formulario
  # Nos vamos a conectar con pluggy para conectar la apykey
  # en ese metodo vamos a guardar el pluggy_item_id en el usuario, vamos a guardar la fecha de hoy en el pluggy_last_update

  def create_bank
    p_client = PluggyClient.new
    unless current_user.pluggy_item_id
      items = p_client.fetch_items(0, { user: params[:bank]["user"], password: params[:bank]["password"] })
      current_user.pluggy_item_id = items["id"]
      current_user.save
    end
    accounts = []
    5.times do
      # accounts = p_client.fetch_accounts(current_user.pluggy_item_id)
      break unless accounts.empty?
    end
    if accounts.empty?
      flash[:warning] = "Wow! Parece que hubo un problema, vuelve a intentarlo!"
      @expense = Expense.new
      render :new
    else
      # get the transaccions for the account
      transactions = p_client.fetch_transactions(accounts[0]["id"])
      parse_transactions(transactions)
      current_user.pluggy_last_update = Date.today
      current_user.save
      # armo expenses con las transactions
      # transactions["results"] => array de hashes
      # usar p_client.transactions["results"].select { |t| ["Credit Card", "Transfer"].include?(t["category"])
      redirect_to expenses_path
    end 
  end

  def sync_bank_account
    p_client = PluggyClient.new
    accounts = p_client.fetch_accounts(current_user.pluggy_item_id)
    # params could be: {from: "date", to: "date", pageSize: 150}
    transactions = p_client.fetch_transactions(accounts[0]["id"], {from: current_user.pluggy_last_update, pageSize: 150})
    parse_transactions(transactions)
    current_user.pluggy_last_update = Date.today
    current_user.save
    redirect_to expenses_path
  end

  private

  def parse_transactions(transactions)
    transactions["results"].each do |transaction|
      if (transaction["amount"]).negative? && transaction["category"] != "Taxes"
        if transaction["category"] == "Entertainment" || transaction["category"] == "Online Subscriptions"
          @expense = Expense.new(category: "Entretenimiento", amount: transaction["amount"].abs.to_i, description: transaction["description"], created_at: transaction["date"] )
          @expense.user = current_user
          @saving = current_user.savings.last
          @expense.saving = @saving
          if @expense.save!
            @saving.total_amount += (@expense.amount * current_user.saving_percentage) / 100
            @saving.save
          end
        elsif transaction["category"] == "Services"
          @expense = Expense.new(category: "Servicios", amount: transaction["amount"].to_i.abs, description: transaction["description"], created_at: transaction["date"] )
          @expense.user = current_user
          @saving = current_user.savings.last
          @expense.saving = @saving
          if @expense.save!
            @saving.total_amount += (@expense.amount * current_user.saving_percentage) / 100
            @saving.save
          end
        elsif transaction["category"] == "Credit Card"
          @expense = Expense.new(category: "Tarjeta de Crédito", amount: transaction["amount"].to_i.abs, description: transaction["description"], created_at: transaction["date"] )
          @expense.user = current_user
          @saving = current_user.savings.last
          @expense.saving = @saving
          if @expense.save!
            @saving.total_amount += (@expense.amount * current_user.saving_percentage) / 100
            @saving.save
          end
        elsif transaction["category"] == "Delivery Services"
          @expense = Expense.new(category: "Gastronomia", amount: transaction["amount"].to_i.abs, description: transaction["description"], created_at: transaction["date"] )
          @expense.user = current_user
          @saving = current_user.savings.last
          @expense.saving = @saving
          if @expense.save!
            @saving.total_amount += (@expense.amount * current_user.saving_percentage) / 100
            @saving.save
          end
        else
          @expense = Expense.new(category: "Otros", amount: transaction["amount"].to_i.abs, description: transaction["description"], created_at: transaction["date"] )
          @expense.user = current_user
          @saving = current_user.savings.last
          @expense.saving = @saving
          if @expense.save!
            @saving.total_amount += (@expense.amount * current_user.saving_percentage) / 100
            @saving.save
          end
        end
      end
    end
  end

  def expense_params
    params.require(:expense).permit(:category, :amount, :description)
  end
end

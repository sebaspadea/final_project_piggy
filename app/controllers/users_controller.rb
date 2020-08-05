class UsersController < ApplicationController

  def show
    @user = current_user
    @expenses = current_user.expenses
    @savings = current_user.savings
  end
end

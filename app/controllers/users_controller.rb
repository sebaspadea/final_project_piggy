class UsersController < ApplicationController

  def show
    @user = current_user
    raise
  end
end

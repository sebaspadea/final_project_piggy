class SavingsController < ApplicationController

  def index
    @savings = Saving.all
  end
end

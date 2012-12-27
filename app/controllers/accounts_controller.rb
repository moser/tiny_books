class AccountsController < ApplicationController
  def index
    # TODO authorize
    @accounts = Account.all
  end

  def show
    @account = Account.find(params[:id])
  end

  def new
    # TODO authorize
    @account = Account.new
  end

  def create
    # TODO authorize
    @account = Account.create(params[:account])
    if @account.valid?
      redirect_to accounts_path
    else
      render action: :new
    end
  end
end

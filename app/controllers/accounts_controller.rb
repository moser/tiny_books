class AccountsController < ApplicationController
  before_filter :authenticate_user!

  def index
    @accounts = Account.all
  end

  def show
    @account = Account.find(params[:id])
  end

  def new
    @account = Account.new
  end

  def create
    @account = Account.create(params[:account])
    if @account.valid?
      redirect_to accounts_path
    else
      render action: :new
    end
  end
end

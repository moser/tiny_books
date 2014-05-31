class AccountsController < ApplicationController
  before_filter :authenticate_user!

  def index
    @accounts = Account.all
    @include_balance = !!params[:balance]
    respond_to do |f|
      f.html
      f.pdf do 
        render pdf: "accounts",
               formats: [:html],
               disable_internal_links: true,
               disable_external_links: true,
               dpi: "90"
      end
    end
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

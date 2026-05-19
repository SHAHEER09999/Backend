class BankAccountsController < ApplicationController
  before_action :set_profile
  before_action :set_bank_account, only: [:update, :destroy]

  def index
    render json: @profile.bank_accounts
  end

  def create
    account = @profile.bank_accounts.new(bank_account_params)

    if account.save
      render json: account, status: :created
    else
      render json: { errors: account.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    if @bank_account.update(bank_account_params)
      render json: @bank_account
    else
      render json: { errors: @bank_account.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    @bank_account.destroy
    render json: { message: "Deleted successfully" }
  end

  private

  def set_profile
    @profile = Profile.find(params[:profile_id])
  end

  def set_bank_account
    @bank_account = @profile.bank_accounts.find(params[:id])
  end

  def bank_account_params
    params.require(:bank_account).permit(:account_name, :account_number)
  end
end
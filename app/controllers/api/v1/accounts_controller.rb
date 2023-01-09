# frozen_string_literal: true

module Api
  module V1
    class AccountsController < BaseController
      def create
        account = Account.create!

        render json: account, only: [:id], status: :created
      end
    end
  end
end

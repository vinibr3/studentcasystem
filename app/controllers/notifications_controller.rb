class NotificationsController < ApplicationController
  skip_before_filter :verify_authenticity_token, only: :create

  def create
    transaction = PagSeguro::Transaction.find_by_code(params[:notificationCode])

    if transaction.errors.empty?
      carteirinha = Carteirinha.find transaction.reference
      carteirinha.forma_pagamento = transaction.payment_method.description
      carteirinha.status_pagamento = transaction.status.id
      carteirinha.transaction_id = transaction.code
      carteirinha.valor = transaction.gross_amount.to_f
      carteirinha.save!
    end

    render json: transaction.errors, status: 200
  end

  private
    def notifications_params
      params.require(:notifications).permit(:notificationCode, :notificationType)
    end

end

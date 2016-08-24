class NotificationsController < ApplicationController
  skip_before_filter :verify_authenticity_token, only: :create
  
  def create
    transaction = PagSeguro::Transaction.find_by_code(params[:notificationCode])
    @estudante = Estudante.find(transaction.reference)

    if transaction.errors.empty?
      Carteirinha.where(transaction_id: transaction.code) do |c|
        transaction.status.id <= 3 # status pagamento é anterior ou igual a 'Pago'
          c.nome = @estudante.nome                                                  
          c.rg = @estudante.rg
          c.cpf = @estudante.cpf
          c.data_nascimento = @estudante.data_nascimento
          c.matricula = @estudante.matricula
          c.expedidor_rg = @estudante.expedidor_rg
          c.uf_expedidor_rg = @estudante.uf_expedidor_rg
          @instituicao = InstituicaoEnsino.find(@estudante.instituicao_ensino_id)
          c.instituicao_ensino = @instituicao.nome
          c.cidade_inst_ensino = @instituicao.cidade.nome
          c.escolaridade = @estudante.escolaridade.nome
          c.uf_inst_ensino = @instituicao.estado.sigla
          c.curso_serie = @estudante.curso.nome
          c.foto = @estudante.foto
          c.layout_carteirinha = LayoutCarteirinha.last
          c.estudante_id = @estudante.id
          c.status_pagamento = transaction.status.id
          c.forma_pagamento = transaction.payment_method.description
          c.transaction_id = transaction.code
          c.valor = transaction.gross_amount.to_f
          c.forma_pagamento = transaction.payment_method.description
          c.status_pagamento = transaction.status.id
          c.transaction_id = transaction.code
          c.valor = transaction.gross_amount.to_f
      end
    end
      render nothing: true, status: 200
  end

  private
    def notifications_params
      params.require(:notifications).permit(:notificationCode, :notificationType)
    end

end

# @carteirinha = current_estudante.carteirinhas.new(carteirinha_params) do |c|
      # c.nome = current_estudante.nome
      # c.rg = current_estudante.rg
      # c.cpf = current_estudante.cpf
      # c.data_nascimento = current_estudante.data_nascimento
      # c.matricula = current_estudante.matricula
      # c.expedidor_rg = current_estudante.expedidor_rg
      # c.uf_expedidor_rg = current_estudante.uf_expedidor_rg
      # @instituicao = InstituicaoEnsino.find(current_estudante.instituicao_ensino_id)
      # c.instituicao_ensino = @instituicao.nome
      # c.cidade_inst_ensino = @instituicao.cidade.nome
      # c.escolaridade = current_estudante.escolaridade.nome
      # c.uf_inst_ensino = @instituicao.estado.sigla
      # c.curso_serie = current_estudante.curso.nome
      # c.foto = current_estudante.foto
      # c.layout_carteirinha = LayoutCarteirinha.last
      # status = Carteirinha.class_variable_get(:@@STATUS_VERSAO_IMPRESSA)
      # c.status_versao_impressa = status[0]
      # end 
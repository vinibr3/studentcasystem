class NotificationsController < ApplicationController
  skip_before_filter :verify_authenticity_token, only: :create
  before_filter :set_cors_headers

  def create
    transaction = PagSeguro::Transaction.find_by_notification_code(params[:notificationCode])

    if transaction.errors.empty?
      @estudante = Estudante.find(transaction.reference)
      if transaction.status.id.to_i <= 3 # status pagamento é anterior ou igual a 'Pago'
        cart = Carteirinha.where(transaction_id: transaction.code.to_s).first_or_create! do |c|
          c.nome = @estudante.nome                                             
          c.rg = @estudante.rg
          c.cpf = @estudante.cpf
          c.data_nascimento = @estudante.data_nascimento
          c.matricula = @estudante.matricula
          c.expedidor_rg = @estudante.expedidor_rg
          c.uf_expedidor_rg = @estudante.uf_expedidor_rg
          @instituicao = @estudante.instituicao_ensino
          c.instituicao_ensino = @instituicao.nome
          c.cidade_inst_ensino = @instituicao.cidade.nome
          c.escolaridade = @estudante.escolaridade.nome
          c.uf_inst_ensino = @instituicao.estado.sigla
          c.curso_serie = @estudante.curso.nome
          c.foto = @estudante.foto
          c.xerox_rg = @estudante.xerox_rg
          c.xerox_cpf = @estudante.xerox_cpf
          c.comprovante_matricula = @estudante.comprovante_matricula
          c.status_versao_impressa = :pagamento
          c.layout_carteirinha = @estudante.entidade.layout_carteirinhas.last if @estudante.entidade.layout_carteirinhas
          c.estudante_id = @estudante.id
          c.transaction_id = transaction.code
          c.valor = transaction.gross_amount.to_f
          c.set_forma_pagamento_by_type(transaction.payment_method.type_id)
          c.set_status_pagamento_by_code(transaction.status.id)
        end
        if cart.status_pagamento_to_i <= 2 && transaction.status.id == "3" # status avançou para 'pago'
            cart.update_attribute(status_versao_impressa: Carteirinha.status_versao_impressas[1].first) # muda status para 'Documentação'
        end
        cart.set_status_pagamento_by_code(transaction.status.code)
        cart.save
      end
    end
    render nothing: true, status: 200
  end

  private
    def notifications_params
      params.permit(:notificationCode, :notificationType)
    end

    def set_cors_headers
      headers['Access-Control-Allow-Origin'] = 'https://sandbox.pagseguro.uol.com.br'
    end

    def index_in_bounds index, size
      index >= 0 && index < size
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
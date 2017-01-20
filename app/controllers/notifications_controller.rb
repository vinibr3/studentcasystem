class NotificationsController < ApplicationController
  skip_before_filter :verify_authenticity_token, only: :create
  before_filter :set_cors_headers

  def create
    transaction = PagSeguro::Transaction.find_by_notification_code(params[:notificationCode])
    if transaction.errors.empty?
      estudante = Estudante.find(transaction.reference)
      if estudante
        carteirinha = estudante.carteirinhas.where(transaction_id: transaction.code.to_s)
        if carteirinha
          carteirinha.update(status_pagamento: Carteirinha.status_pagamento_by_code(transaction.status.id))
          if carteirinha.status_pagamento_to_i <= 2 && transaction.status.id == "3" # status avançou para 'pago'
            statuses = Carteirinha.status_versao_impressas.map{|k,v|}
            carteirinha.update(status_versao_impressa: statuses[1]) # muda status para 'Documentação'
          end
          render nothing: true, status: 201
        else
          estudante.carteirinhas.build do |c|
            c.nome = estudante.nome                                             
            c.rg = estudante.rg
            c.cpf = estudante.cpf
            c.data_nascimento = estudante.data_nascimento
            c.matricula = estudante.matricula
            c.expedidor_rg = estudante.expedidor_rg
            c.uf_expedidor_rg = estudante.uf_expedidor_rg
            instituicao = estudante.instituicao_ensino
            c.instituicao_ensino = instituicao.nome
            c.cidade_inst_ensino = instituicao.cidade.nome
            c.escolaridade = estudante.escolaridade.nome
            c.uf_inst_ensino = instituicao.estado.sigla
            c.curso_serie = estudante.curso.nome
            c.foto = estudante.foto
            c.xerox_rg = estudante.xerox_rg
            c.xerox_cpf = estudante.xerox_cpf
            c.comprovante_matricula = estudante.comprovante_matricula
            c.status_versao_impressa = :pagamento
            c.layout_carteirinha = estudante.entidade.layout_carteirinhas.last if estudante.entidade.layout_carteirinhas
            c.estudante_id = estudante.id
            c.transaction_id = transaction.code
            c.valor = transaction.gross_amount.to_f
            c.forma_pagamento = Carteirinha.forma_pagamento_by_type(transaction.payment_method.type_id)
            c.status_pagamento = Carteirinha.status_pagamento_by_code(transaction.status.id)
          end
        end
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
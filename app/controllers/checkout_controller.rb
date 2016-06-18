class CheckoutController < ApplicationController
  
  def create
    # O modo como você irá armazenar os produtos que estão sendo comprados
    # depende de você. Neste caso, temos um modelo Order que referência os
    # produtos que estão sendo comprados.
    
    carteirinha = Carteirinha.find(params[:id])
    estudante = carteirinha.estudante 

    payment = PagSeguro::PaymentRequest.new
    payment.reference = carteirinha.id
    payment.notification_url = ENV['PAGSEGURO_URL_NOTIFICATION']
    payment.redirect_url = ENV['PAGSEGURO_URL_CALLBACK']

   entidade = Entidade.instance
    # Informações de pagamento da carteirinha
    payment.items << {
      id: carteirinha.id,
      quantity: 1,
      description: "Carteira de Identificação Estudantil",
      amount: entidade.valor_carteirinha
    }

    # Taxa de serviço do pagseguro
    valor_total = entidade.valor_carteirinha.to_f unless entidade.valor_carteirinha.blank?
    valor_total += entidade.frete_carteirinha.to_f unless entidade.frete_carteirinha.blank?
    amount = (valor_total+0.4)/0.95
    amount = amount-valor_total
    payment.items << {
      id: carteirinha.id,
      quantity: 1,
      description: "Taxa de serviços bancários (Pagseguro)",
      amount: amount,
      shipping_cost: entidade.frete_carteirinha,
    }
    
    # Informações do comprador
    payment.sender = {
      name: estudante.nome,
      email: estudante.email,
      phone: {
        area_code: estudante.celular.first(2),
        number: estudante.celular.from(2)
      }
    }

    # Configurações de envio
    payment.shipping = {
      type_name: 'not_specified',
      cost: entidade.frete_carteirinha,
      address: {
        street: estudante.logradouro,
        number: estudante.numero,
        complement: estudante.complemento,
        district: estudante.setor,
        city: estudante.cidade,
        state: estudante.uf,
        postal_code: estudante.cep
      }
    } unless entidade.frete_carteirinha.blank?

    payment.max_uses = 100
    payment.max_age = 3600  # em segundos

    # Caso você precise passar parâmetros para a api que ainda não foram mapeados na gem,
    # você pode fazer de maneira dinâmica utilizando um simples hash.
    # payment.extra_params << { paramName: 'paramValue' }
    # payment.extra_params << { senderBirthDate: '07/05/1981' }
    # payment.extra_params << { extraAmount: '-15.00' }

    response = payment.register

    # Caso o processo de checkout tenha dado errado, lança uma exceção.
    # Assim, um serviço de rastreamento de exceções ou até mesmo a gem
    # exception_notification poderá notificar sobre o ocorrido.
    #
    # Se estiver tudo certo, redireciona o comprador para o PagSeguro.
    if response.errors.any?
      raise response.errors.join("\n")
    else
      redirect_to response.url
    end
  end

  def checkout_params
  	params.require(:checkout).permit(:id)
  end

end
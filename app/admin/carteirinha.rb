require 'zip'
ActiveAdmin.register Carteirinha do
   menu priority: 3
   actions :all, except: [:destroy, :new]
   
   scope "Todas", :all, default: true

   Carteirinha.status_versao_impressas.each do |status|
    scope status.second do |carteirinha|
        if current_admin_user.super_admin?
          carteirinha.where(status_versao_impressa: status.second)
        else
          carteirinha.where(status_versao_impressa: status.second, alterado_por: current_admin_user.usuario)
        end
    end
   end 

    permit_params :nome, :instituicao_ensino, :curso_serie, :matricula, :rg,
				  :data_nascimento, :cpf, :numero_serie, :validade, :qr_code,
				  :layout_carteirinha_id, :vencimento, :estudante_id, :foto, 
          :status_versao_impressa, :expedidor_rg, :uf_expedidor_rg,
          :cidade_inst_ensino,:escolaridade, :uf_inst_ensino, 
          :foto_file_name, :nao_antes, :nao_depois, :codigo_uso,
          :alterado_por, :valor, :forma_pagamento, :status_pagamento, 
          :transaction_id, :certificado, :xerox_rg, :xerox_cpf, 
          :comprovante_matricula, :carteirinha, :id
	
  filter :nome
	filter :numero_serie
  filter :transaction_id
	
	index do
		selectable_column
    	column :nome 
    	column "Curso" do |carteirinha|
        carteirinha.curso_serie
      end
      column "Instituição de Ensino" do |carteirinha|
        carteirinha.instituicao_ensino
      end
      column "Valor Pago" do |carteirinha|
        carteirinha.valor
      end
      column "Status do Pagamento" do |carteirinha|
        status_tag(carteirinha.status_pagamento, carteirinha.status_tag_status_pagamento )
      end
      column "Status da Solicitaçao" do |carteirinha|
        status_tag(carteirinha.status_versao_impressa.humanize, carteirinha.status_tag_versao_impressa)
      end
      column :alterado_por
      actions
	end

    show do
        panel "Dados do Estudante" do 
            attributes_table_for carteirinha do 
                row :nome 
                row :rg
                row :cpf
                row :data_nascimento
                row :foto do 
                    a carteirinha.foto_file_name, class: "show-popup-link", href: carteirinha.foto.url
                end
                row :xerox_rg do 
                    a carteirinha.xerox_rg_file_name, href: carteirinha.xerox_rg.url
                end
                 row :xerox_cpf do
                    a carteirinha.xerox_cpf_file_name, href: carteirinha.xerox_cpf.url
                end
            end
        end
        panel "Dados Escolares" do 
            attributes_table_for carteirinha do
                row :instituicao_ensino
                row :cidade_inst_ensino
                row :uf_inst_ensino
                row :escolaridade
                row :curso_serie
                row :matricula
                row :comprovante_matricula do
                    a carteirinha.comprovante_matricula_file_name, href: carteirinha.comprovante_matricula.url
                end
            end
        end
        panel "Dados da Carteirinha" do
            attributes_table_for carteirinha do 
                row :nao_antes
                row :nao_depois 
                row :codigo_uso
                row :qr_code
                row :certificado
                row :numero_serie
                row :layout_carteirinha_id
                row :estudante_id
            end
        end
        panel "Dados da Solicitaçao" do 
            attributes_table_for carteirinha do
                row "Status" do 
                    carteirinha.status_versao_impressa.humanize
                end
                row :valor
                row "Forma Pagamento" do
                  carteirinha.forma_pagamento.humanize
                end
                row "Status Pagamento" do
                  carteirinha.status_pagamento.humanize
                end 
                row "Transação" do
                  carteirinha.transaction_id
                end
                row :alterado_por
            end
        end
        render inline: "<script type='text/javascript'>$('.show-popup-link').magnificPopup({type: 'image'});</script>"
    end

    form do |f|
        f.semantic_errors *f.object.errors.keys
            # f.inputs "Dados do Estudante" do
            #     f.input :nome 
            #     f.input :rg
            #     f.input :cpf
            #     f.input :data_nascimento, as: :datepicker
            #     f.input :foto, :hint => "Imagem Atual: #{f.object.foto_file_name}"
            #     f.input :xerox_rg, :hint => "Imagem Atual: #{f.object.xerox_rg_file_name}"
            #     f.input :xerox_cpf, :hint => "Imagem Atual: #{f.object.xerox_cpf_file_name}"
            # end
            # f.inputs "Dados Escolares" do
            #     f.input :instituicao_ensino, collection: InstituicaoEnsino.all.map{|i| [i.nome, i.nome] }, include_blank: false
            #     f.input :curso_serie, collection: Curso.all.map{|c| [c.nome, c.nome]}, include_blank: false, label: "Curso"
            #     f.input :escolaridade, collection: Escolaridade.all.map{|e| [e.nome, e.nome]}, include_blank: false, label: "Escolaridade"
            #     f.input :matricula
            #     f.input :comprovante_matricula, :hint => "Imagem Atual: #{f.object.comprovante_matricula_file_name}"
            # end
            # f.inputs "Dados do Documento" do
            #     f.input :nao_antes, as: :datepicker
            #     f.input :nao_depois, as: :datepicker
            #     f.input :codigo_uso
            #     f.input :qr_code
            #     f.input :certificado
            #     f.input :numero_serie
            #     f.input :layout_carteirinha_id, label:"Layout"
            #     f.input :estudante_id, label: "Estudante ID"
            # end 
            f.inputs "Dados da Solicitação" do
                f.input :status_pagamento, as: :select, include_blank: false, prompt: "Selecione status do pagamento", label: "Status do Pagamento"
                f.input :status_versao_impressa, collection: f.object.show_status_carteirinha_apartir_do_status_pagamento, label: "Status da Solicitação", include_blank: false
                f.input :forma_pagamento, as: :select, include_blank: false, prompt: "Selecione forma de pagamento", label: "Forma de Pagamento"
                f.input :transaction_id, label: "Transação"
                #f.input :alterado_por, label: "Alterado por"
            end
            f.actions

    end

    before_update do |carteirinha|
        carteirinha.alterado_por = current_admin_user.usuario
    end

    #Actions
    member_action :download, method: :get do
       carteirinha = Carteirinha.find(params[:id])
       if carteirinha
        if carteirinha.status_versao_impressa_to_i < 2 
            flash[:error]="Status da CIE não permite o download."
            redirect_to :back
        else
            send_data carteirinha.to_blob, type: 'image/jpg', filename: "#{carteirinha.numero_serie}.jpg" 
        end
       else
        flash[:error]="Dados não encontrados."
        redirect_to :back
       end
    end

    collection_action :download_all, method: :get do
       @carteirinhas = Carteirinha.find(params[:carteirinhas_ids]) if params[:carteirinhas_ids]
       @carteirinhas.delete_if{|carteirinha| carteirinha.status_versao_impressa_to_i < 2}  if @carteirinhas # Status anterior a 'Aprovada'
       if @carteirinhas
        data = Carteirinha.zipfile_by_scope @carteirinhas
        send_data  data[:stream], type:'application/zip', filename: data[:filename]
       else
        flash[:error] =  "Dados não encontrados."
        redirect_to :back
       end
    end
    #Action items 
    action_item :download, only: :show do
        link_to 'Download ', download_admin_carteirinha_path(carteirinha)
    end

    action_item :download_all, only: :index do
        ids=Array.new
        collection.each{ |collection| ids<<collection.id}
        link_to 'Download', download_all_admin_carteirinhas_path(:carteirinhas_ids => ids)
    end

    controller do
      def create
        @estudante = Estudante.find(params[:estudante_id])
        @carteirinha = nil
        atributos = @estudante.atributos_nao_preenchidos
          if atributos.count > 0 
            campos = ""
            atributos.collect{|f| campos.concat(f.concat(", "))}
            puts "ATRIBUTOS #{atributos}"
            flash[:alert] = "Não foi possível criar carteirinha. Campo(s) #{campos} não preenchido(s)."
            redirect_to edit_admin_estudante_path @estudante
          else
            @carteirinha = @estudante.carteirinhas.build do |c|
            # Dados pessoais
            c.nome = @estudante.nome
            c.rg   = @estudante.rg
            c.cpf  = @estudante.cpf
            c.data_nascimento = @estudante.data_nascimento
            c.expedidor_rg = @estudante.expedidor_rg
            c.uf_expedidor_rg = @estudante.uf_expedidor_rg
            c.foto = @estudante.foto
            c.xerox_rg = @estudante.xerox_rg
            c.xerox_cpf = @estudante.xerox_cpf
            c.comprovante_matricula = @estudante.comprovante_matricula

            # Dados estudantis
            c.matricula = @estudante.matricula
            c.instituicao_ensino = @estudante.instituicao_ensino.nome
            c.cidade_inst_ensino = @estudante.instituicao_ensino.cidade.nome
            c.uf_inst_ensino = @estudante.instituicao_ensino.estado.sigla
            c.escolaridade = @estudante.escolaridade_nome
            c.curso_serie = @estudante.curso_nome
              
            # Dados de pagamento
            c.valor = @estudante.entidade.valor_carteirinha.to_f+@estudante.entidade.frete_carteirinha.to_f
            c.status_versao_impressa = :pagamento #status versao impressa
            c.status_pagamento = :iniciada  #status pagamento
            c.forma_pagamento = :a_definir  #forma pagamento
              
            # Layout 
            if @estudante.entidade.layout_carteirinhas
              c.layout_carteirinha = @estudante.entidade.layout_carteirinhas.last
            else
              flash[:alert] = "Não foi possível criar carteirinha. Entidade #{@estudante.entidade.nome} não tem nenhum layout de carteirinha."
              redirect_to estudante_admin_path @estudante
            end
          end

          if @carteirinha.save! 
            flash[:success] = "Carteirinha criada para o estudante: #{@estudante.nome}. Altere os dados de pagamento."
            redirect_to edit_carteirinha_admin_path @carteirinha
          else
            flash[:error] = "Não foi possível criar carteirinha. @carteirinha.errors"
            redirect_to estudante_admin_path @estudante
          end
        end
      end

      def update(options={}, &block)
        if resource.status_versao_impressa != params[:carteirinha][:status_versao_impressa]  
          #EstudanteNotificacoes.status_notificacoes(@carteirinha).deliver_now if resource.update_attributes(permitted_params[:carteirinha])
        end
        super do |success, failure| 
          block.call(success, failure) if block
          failure.html { render :edit }
        end
      end
    end
end
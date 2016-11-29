require 'zip'
ActiveAdmin.register Carteirinha do
   menu priority: 3
   actions :all, except: [:new,:delete]
   
   scope "Todas", :all, default: true
   
   status = Carteirinha.status_versao_impressa

   status.each do |status|
    scope status do |carteirinha|
        if current_admin_user.super_admin?
            carteirinha.where(status_versao_impressa: status)
        else
            carteirinha.where(status_versao_impressa: status, alterado_por: current_admin_user.usuario)
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
    #filter :status_versao_impressa, as: :select, collection: proc {Carteirinha.class_variable_get(:@@STATUS_VERSAO_IMPRESSA)}
	filter :numero_serie
    filter :transaction_id
	
	index do
		selectable_column
    	column :nome 
    	column :curso_serie
        column :instituicao_ensino
        column :valor 
        column :status_pagamento
        column "Status Pedido", :status_versao_impressa
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
                    carteirinha.status_versao_impressa
                end
                row :valor
                row :forma_pagamento
                row :status_pagamento
                row :transaction_id
                row :alterado_por
            end
        end
        render inline: "<script type='text/javascript'>$('.show-popup-link').magnificPopup({type: 'image'});</script>"
    end

    form do |f|
        f.semantic_errors *f.object.errors.keys
        if current_admin_user.super_admin?
            f.inputs "Dados do Estudante" do
                f.input :nome 
                f.input :rg
                f.input :cpf
                f.input :data_nascimento, as: :datepicker
                f.input :foto, :hint => "Imagem Atual: #{f.object.foto_file_name}"
                f.input :xerox_rg, :hint => "Imagem Atual: #{f.object.xerox_rg_file_name}"
                f.input :xerox_cpf, :hint => "Imagem Atual: #{f.object.xerox_cpf_file_name}"
                #f.input :foto
            end
            f.inputs "Dados Escolares" do
                f.input :instituicao_ensino, collection: InstituicaoEnsino.all.map{|i| [i.nome, i.nome] }, include_blank: false
                f.input :curso_serie, collection: Curso.all.map{|c| [c.nome, c.nome]}, include_blank: false, label: "Curso"
                f.input :escolaridade, collection: Escolaridade.all.map{|e| [e.nome, e.nome]}, include_blank: false, label: "Curso"
                f.input :matricula
                f.input :comprovante_matricula, :hint => "Imagem Atual: #{f.object.comprovante_matricula_file_name}"
            end
            f.inputs "Dados do Documento" do
                f.input :nao_antes, as: :datepicker
                f.input :nao_depois, as: :datepicker
                f.input :codigo_uso
                f.input :qr_code
                f.input :certificado
                f.input :numero_serie
                f.input :layout_carteirinha_id
                f.input :estudante_id, label: "Estudante ID"
            end 
        end
            f.inputs "Dados da Solicitação" do
                f.input :status_versao_impressa, as: :select, collection: resource.show_status_carteirinha_apartir_do_status_pagamento, label: "Status", include_blank: false
                #f.input :status_versao_digital
                if current_admin_user.super_admin?
                    f.input :alterado_por
                    f.input :valor 
                    f.input :forma_pagamento
                    f.input :status_pagamento, collection: Carteirinha.class_variable_get(:@@status_pagamento), include_blank: false
                    f.input :transaction_id
                end
            end
            f.actions

    end

    before_update do |carteirinha|
        carteirinha.alterado_por = current_admin_user.usuario
    end

    controller do
      def update(options={}, &block)
        puts "OPTIONS: #{options}"
        if resource.status_versao_impressa != params[:carteirinha][:status_versao_impressa]  
          #EstudanteNotificacoes.status_notificacoes(@carteirinha).deliver_now if resource.update_attributes(permitted_params[:carteirinha])
        end
        super do |success, failure| 
          block.call(success, failure) if block
          failure.html { render :edit }
        end
      end
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
end
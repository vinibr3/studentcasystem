require 'zip'
ActiveAdmin.register Carteirinha do
   menu priority: 3
   actions :all, except: [:new, :delete]
   
   scope "Todas", :all, default: true
   
   status = Carteirinha.status_versao_impressa

   scope :pagamento do |carteirinha|
        if current_admin_user.super_admin?
            carteirinha.where(status_versao_impressa: status[0])
        else
            carteirinha.where(status_versao_impressa: status[0], alterado_por: current_admin_user.usuario)
        end
   end
   scope "Documentação" do |carteirinha|
        if current_admin_user.super_admin?
            carteirinha.where(status_versao_impressa:  status[1])
        else
            carteirinha.where(status_versao_impressa:  status[1], alterado_por: current_admin_user.usuario)
        end
   end
   scope :aprovada do |carteirinha|
        if current_admin_user.super_admin?
            carteirinha.where(status_versao_impressa: status[2])
        else
            carteirinha.where(status_versao_impressa: status[2], alterado_por: current_admin_user.usuario)
        end
   end
   scope :entregue do |carteirinha|
        if current_admin_user.super_admin?
            carteirinha.where(status_versao_impressa: status[3])
        else
            carteirinha.where(status_versao_impressa: status[3], alterado_por: current_admin_user.usuario)
        end
   end
   scope :enviada do |carteirinha|
        if current_admin_user.super_admin?
            carteirinha.where(status_versao_impressa: status[4])
        else
            carteirinha.where(status_versao_impressa: status[4], alterado_por: current_admin_user.usuario)
        end
   end

    permit_params :nome, :instituicao_ensino, :curso_serie, :matricula, :rg,
				  :data_nascimento, :cpf, :numero_serie, :validade, :qr_code,
				  :layout_carteirinha_id, :versao_digital, :versao_impressa,
				  :vencimento, :estudante_id, :foto, :status_versao_digital, 
                  :status_versao_impressa, :expedidor_rg, :uf_expedidor_rg,
                  :cidade_inst_ensino,:escolaridade, :uf_inst_ensino, 
                  :foto_file_name, :nao_antes, :nao_depois, :codigo_uso,
                  :alterado_por, :valor, :forma_pagamento, :status_pagamento, 
                  :transaction_id

	filter :nome
    filter :status_versao_impressa, as: :select, collection: proc {Carteirinha.class_variable_get(:@@STATUS_VERSAO_IMPRESSA)}
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
            end
        end
        panel "Dados do Documento" do
            attributes_table_for carteirinha do 
                row :nao_antes
                row :nao_depois 
                row :codigo_uso
                row :qr_code
               #row :certificado
                row :numero_serie
                row :layout_carteirinha_id
                row :estudante_id
            end
        end
        panel "Dados da Solicitaçao" do 
            attributes_table_for carteirinha do
                row :status_versao_impressa
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
                #f.input :foto_file_name
            end
            f.inputs "Dados Escolares" do
                f.input :instituicao_ensino
                f.input :cidade_inst_ensino
                f.input :uf_inst_ensino
                f.input :escolaridade
                f.input :curso_serie
                f.input :matricula
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
                f.input :status_versao_impressa, as: :select, collection: Carteirinha.class_variable_get(:@@STATUS_VERSAO_IMPRESSA)
                #f.input :status_versao_digital
                if current_admin_user.super_admin?
                    f.input :alterado_por
                    f.input :valor
                    f.input :forma_pagamento
                    f.input :status_pagamento
                    f.input :transaction_id
                end
            end
            f.actions

    end

    before_update do |carteirinha| 
        carteirinha.alterado_por = current_admin_user.usuario
    end

    #Actions
    member_action :download, method: :get do
       carteirinha = Carteirinha.find(params[:id])
       send_data carteirinha.to_blob, type: 'image/jpg', filename: "#{carteirinha.numero_serie}.jpg"
    end

    collection_action :download_all, method: :get do
       data = Carteirinha.zipfile_by_scope params[:scope] 
       send_data  data[:stream], type:'application/zip', filename: data[:filename]
    end
    #Action items 
    action_item :download, only: :show do
        link_to 'Download ', download_admin_carteirinha_path(carteirinha)
    end

    action_item :download_all, only: :index do
        link_to 'Download', download_all_admin_carteirinhas_path
    end
end
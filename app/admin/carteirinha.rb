ActiveAdmin.register Carteirinha do
   menu priority: 3
   actions :all, except: [:new, :delete]
   
   scope "Todas", :all, default: true
   
   scope :pagamento do |carteirinha|
        if current_admin_user.super_admin?
            carteirinha.where(status_versao_impressa: "Pagamento")
        else
            carteirinha.where(status_versao_impressa: "Pagamento", alterado_por: current_admin_user.usuario)
        end
   end
   scope "Documentação" do |carteirinha|
        if current_admin_user.super_admin?
            carteirinha.where(status_versao_impressa: "Documentação")
        else
            carteirinha.where(status_versao_impressa: "Documentação", alterado_por: current_admin_user.usuario)
        end
   end
   scope :aprovada do |carteirinha|
        if current_admin_user.super_admin?
            carteirinha.where(status_versao_impressa: "Aprovada")
        else
            carteirinha.where(status_versao_impressa: "Aprovada", alterado_por: current_admin_user.usuario)
        end
   end
   scope :entregue do |carteirinha|
        if current_admin_user.super_admin?
            carteirinha.where(status_versao_impressa: "Enviada")
        else
            carteirinha.where(status_versao_impressa: "Enviada", alterado_por: current_admin_user.usuario)
        end
   end
   scope :enviada do |carteirinha|
        if current_admin_user.super_admin?
            carteirinha.where(status_versao_impressa: "Entregue")
        else
            carteirinha.where(status_versao_impressa: "Entregue", alterado_por: current_admin_user.usuario)
        end
   end

    permit_params :nome, :instituicao_ensino, :curso_serie, :matricula, :rg,
				  :data_nascimento, :cpf, :numero_serie, :validade, :qr_code,
				  :layout_carteirinha_id, :versao_digital, :versao_impressa,
				  :vencimento, :estudante_id, :foto, :status_versao_digital, 
                  :status_versao_impressa, :expedidor_rg, :uf_expedidor_rg,
                  :cidade_inst_ensino,:escolaridade, :uf_inst_ensino, 
                  :foto_file_name, :nao_antes, :nao_depois, :codigo_uso,
                  :alterado_por, :valor, :forma_pagamento, :numero_boleto

	filter :nome
    filter :status_versao_impressa, as: :select, collection: proc {Carteirinha.class_variable_get(:@@STATUS_VERSAO_IMPRESSA)}
	filter :matricula
	filter :rg
	filter :cpf
	filter :numero_serie
	filter :qr_code
	
	index do
		selectable_column
    	column :nome 
    	column :curso_serie
        column :instituicao_ensino
        column :valor 
        column :forma_pagamento
        column :numero_boleto
        column "Status", :status_versao_impressa
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
                row :foto_file_name
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
                row :status_versao_digital
                row :alterado_por
                row :valor
                row :forma_pagamento
                row :numero_boleto
            end
        end
    end

    form do |f|
        if current_admin_user.super_admin?
            f.inputs "Dados do Estudante" do
                f.input :nome 
                f.input :rg
                f.input :cpf
                f.input :data_nascimento
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
                f.input :estudante_id
            end 
        end
            f.inputs "Dados da Solicitação" do
                f.input :status_versao_impressa, as: :select, collection: Carteirinha.class_variable_get(:@@STATUS_VERSAO_IMPRESSA)
                #f.input :status_versao_digital
                if current_admin_user.super_admin?
                    f.input :alterado_por
                    f.input :valor
                    f.input :forma_pagamento
                    f.input :numero_boleto
                end
            end
            f.actions

    end

    before_update do |carteirinha| 
        aprovada = Carteirinha.class_variable_get(:@@STATUS_VERSAO_IMPRESSA)
        aprovada = aprovada[2]
        if carteirinha.status_versao_impressa == aprovada 
            carteirinha.layout_carteirinha_id = LayoutCarteirinha.last_layout_id        if carteirinha.layout_carteirinha_id.blank?
            carteirinha.nao_antes = Time.new                                            if carteirinha.nao_antes.blank?
            carteirinha.nao_depois = Time.new(Time.new.year+1, 3, 31).to_date           if carteirinha.nao_depois.blank? 
            carteirinha.numero_serie = Carteirinha.gera_numero_serie(carteirinha.id)    if carteirinha.numero_serie.blank?
            carteirinha.codigo_uso = Carteirinha.gera_codigo_uso                        if carteirinha.codigo_uso.blank?
            carteirinha.qr_code = Carteirinha.gera_qr_code                              if carteirinha.qr_code.blank?
            carteirinha.certificado = Carteirinha.gera_certificado(carteirinha)         if carteirinha.certificado.blank?
        end
        carteirinha.alterado_por = current_admin_user.usuario
    end
end
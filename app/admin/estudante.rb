ActiveAdmin.register Estudante do
  menu priority: 2
  actions :all, except: [:new]

  jcropable

  permit_params :nome, :cpf, :rg, :data_nascimento, :sexo, :telefone,
                :logradouro, :complemento, :setor, :cep, :cidade, :uf,
                :instituicao_ensino, :curso_serie, :matricula, :foto, 
                :comprovante_matricula, :xerox_rg, :email, :password, 
                :celular, :numero, :expedidor_rg, :uf_expedidor_rg,
                :cidade_inst_ensino, :uf_inst_ensino, :xerox_cpf, :instituicao_ensino_id, :curso_id

  filter :email
  filter :nome
  filter :cpf
  filter :rg
  filter :cidade   
  filter :instituicao_ensino
  filter :curso_serie
  filter :matricula

  show do
    panel "Dados Pessoais" do
      attributes_table_for estudante do
        row :nome
        row :email
        row :data_nascimento
        row :cpf
        row :rg
        row :expedidor_rg
        row :uf_expedidor_rg
        row :foto do
          a estudante.foto_file_name, class: "show-popup-link", href: estudante.foto.url
        end
        row :xerox_rg do
          a estudante.xerox_rg_file_name, class: "show-popup-link", href: estudante.xerox_rg.url 
        end
        row :xerox_cpf do
          a estudante.xerox_cpf_file_name, class: "show-popup-link", href: estudante.xerox_cpf.url
        end
        row :sexo
        row :telefone
        row :celular
        row :chave_acesso
        
      end 
    end 
    panel "Dados Escolares" do
      attributes_table_for estudante do
        row :instituicao_ensino
        row :escolaridade
        row :curso_serie
        row :matricula
        row :comprovante_matricula do
          a estudante.comprovante_matricula_file_name, class: "show-popup-link", href: estudante.comprovante_matricula.url
        end
      end
    end
    panel "Endereço" do
      attributes_table_for estudante do
        row :logradouro
        row :numero
        row :complemento
        row :cidade
        row :uf
        row :cep 
      end
    end
    if current_admin_user.super_admin?
      panel "Meta Dados" do 
        attributes_table_for estudante do
          row :foto_file_name
          row :foto_content_type
          row :foto_file_size
          row :foto_update_at
          row :comprovante_matricula_file_name
          row :comprovante_matricula_content_type
          row :comprovante_matricula_file_size
          row :comprovante_matricula_update_at
          row :xerox_rg_file_name
          row :xerox_rg_content_type
          row :xerox_rg_file_size
          row :xerox_rg_update_at
          row :provider
          row :uid 
          row :oauth_token
          row :oauth_expires_at
          row :created_at
          row :updated_at
          row :encrypted_password
          row :reset_password_token
          row :reset_password_sent_at
          row :remember_created_at
          row :sign_in_count
          row :current_sign_in_at
          row :last_sign_in_at
          row :current_sign_in_ip
          row :last_sign_in_ip
        end
      end
    end
  render inline: "<script type='text/javascript'>$('.show-popup-link').magnificPopup({type: 'image'});</script>"
  end

  index do
    selectable_column
    column :email
    column :nome
    column :data_nascimento, as: :datepicker
    column :sexo
    column :telefone
    column :logradouro
    column :cidade 
    column :uf
    actions
  end

  form do |f|
    f.semantic_errors *f.object.errors.keys
    f.inputs "Dados Pessoais" do
      f.input :email
      f.input :nome
      f.input :cpf
      f.input :rg
      f.input :data_nascimento, as: :datepicker
      f.input :sexo
      f.input :telefone
      f.input :celular
      f.input :foto, :hint => "Imagem Atual: #{f.object.foto_file_name}", as: :jcropable, jcrop_options: {aspectRatio: 0.75, showDimensions: false, maxSize: [400,500]}
      f.input :xerox_rg, :hint => "Imagem Atual: #{f.object.xerox_rg_file_name}"
      f.input :xerox_cpf, :hint => "Imagem Atual: #{f.object.xerox_cpf_file_name}"
    end
    f.inputs "Dados Estudantis" do
      f.input :instituicao_ensino, collection: InstituicaoEnsino.all.map{|i| [i.nome, i.id] }, include_blank: false
      f.input :curso, collection: Curso.all.map{|c| [c.nome, c.id]}, include_blank: false
      #f.input :escolaridade
      f.input :matricula
      f.input :comprovante_matricula, :hint => "Imagem Atual: #{f.object.comprovante_matricula_file_name}"
    end
    f.inputs "Endereço" do
      f.input :logradouro
      f.input :numero
      f.input :complemento
      f.input :cep
      f.input :cidade, collection: Cidade.all.map{|c| [c.nome, c.nome]}, include_blank: false
      f.input :uf, collection: Estado.all.map{|e| [e.sigla, e.sigla]}, include_blank: false
    end
    f.actions
  end
end
ActiveAdmin.register AdminUser do
  menu if: proc{current_admin_user.super_admin?}, priority: 7

  scope "Todos", :all, default: true
  scope("Ativos"){|scope| scope.where(status: "1")}
  scope("Inativos"){|scope| scope.where(status: "0")}

  permit_params :nome, :email, :cpf, :rg, :expedidor_rg, :uf_expedidor_rg,
                :data_nascimento, :sexo, :celular, :telefone, :logradouro,
                :numero, :complemento, :setor, :cep, :cidade, :uf, :usuario,
                :super_admin, :status, :password, :password_confirmation

  filter :nome
  filter :usuario
  filter :email

  index do
    selectable_column
    #id_column
    column :nome
    column :usuario
    column :email
    column :data_nascimento
    column :sexo
    column :telefone
    column :logradouro
    column :cidade
    column :uf
    actions
  end

  show do 
        panel "Dados de Usuário" do 
            attributes_table_for admin_user do
                row :id
                row :nome
                row :usuario
                row :email
                row :password
                row :super_admin
                row :status
            end
        end
        panel "Dados Pessoais" do 
          attributes_table_for admin_user do
            row :cpf
            row :rg
            row :expedidor_rg
            row :uf_expedidor_rg
            row :data_nascimento
            row :sexo
            row :celular
            row :telefone
          end
        end
        panel "Endereço" do 
          attributes_table_for admin_user do
            row :logradouro
            row :numero
            row :complemento
            row :setor  
            row :cep
            row :cidade
            row :uf
          end
        end
        panel "Meta Dados" do 
          attributes_table_for admin_user do 
            row :reset_password_token
            row :reset_password_sent_at
            row :remember_created_at
            row :sign_in_count
            row :current_sign_in_at
            row :last_sign_in_at
            row :current_sign_in_ip
            row :last_sign_in_ip
            row :created_at
            row :update_at
          end
        end
    end

  form do |f|
    f.inputs "Dados de Usuário" do 
      f.input :nome
      f.input :usuario
      f.input :email
      f.input :password
      f.input :password_confirmation
      f.input :super_admin, as: :select, collection: ["1", "0"]
      f.input :status, as: :select, collection: ["1", "0"]
    end
    f.inputs "Dados Pessoais" do
      f.input :cpf
      f.input :rg
      f.input :expedidor_rg
      f.input :uf_expedidor_rg
      f.input :data_nascimento, as: :date_picker
      f.input :sexo, as: :select, collection: ["masculino", "feminino"]
      f.input :celular
      f.input :telefone
    end
    f.inputs "Endereço" do 
      f.input :logradouro
      f.input :numero
      f.input :complemento
      f.input :setor 
      f.input :cep
      f.input :cidade 
      f.input :uf 
    end
    f.actions
  end

end

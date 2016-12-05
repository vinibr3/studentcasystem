ActiveAdmin.register Escolaridade do 
	menu priority: 3, parent: "Configurações"
	actions :all, except: [:destroy]

	permit_params :nome, :status

	filter :nome

	index do 
		selectable_column
		column :id
		column :nome
		column :status do |escolaridade|
			status_tag(escolaridade.status, escolaridade.ativo? ? :ok : :warning)
		end
		actions
	end

	show do 
		panel "Detalhes" do
			attributes_table_for escolaridade do
				row :nome
				row :status
			end
		end
	end

	form do |f|
		f.semantic_errors *f.object.errors.keys
		f.inputs "Alterar Escolaridade" do
			f.input :nome
			f.input :status, as: :select, include_blank: false
		end
		f.actions
	end

end
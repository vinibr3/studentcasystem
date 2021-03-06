ActiveAdmin.register Curso do 
	menu priority: 2, parent: "Configurações"
	actions :all, except: [:destroy]

	permit_params :nome, :escolaridade_id, :status

	filter :nome
	filter :escolaridade_id, as: :select, collection: Escolaridade.escolaridades.map{|e| [e.nome, e.id]}, include_blank: true

	index do 
		selectable_column
		column :nome
		column "Escolaridade", :escolaridade_nome
		column :status do |curso|
			status_tag(curso.status, curso.ativo? ? :ok : :warning)
		end
		actions
	end

	show do 
		panel "Detalhes" do
			attributes_table_for curso do
				row :nome
				row "Escolaridade" do
				 curso.escolaridade_nome
				end
				row :status
			end
		end
	end

	form do |f|
		f.semantic_errors *f.object.errors.keys
		f.inputs "Alterar Curso" do
			f.input :nome
			f.input :escolaridade, collection: Escolaridade.escolaridades.map{|e| [e.nome, e.id]}, prompt: "Selecione a Escolaridade", as: :select
			f.input :status, as: :select
		end
		f.actions
	end

end
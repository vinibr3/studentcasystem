ActiveAdmin.register Curso do 
	menu priority: 6, parent: "Configurações"
	actions :all

	permit_params :nome, :escolaridade_id

	filter :nome
	filter :escolaridade_id, as: :select, collection: Escolaridade.where(status: "1").map{|e| [e.nome, e.id]}, include_blank: true

	index do 
		selectable_column
		column :nome
		column "Escolaridade", :escolaridade_nome
		actions
	end

	show do 
		panel "Detalhes" do
			attributes_table_for curso do
				row :nome
				row "Escolaridade" do
				 curso.escolaridade_nome
				end
			end
		end
	end

	form do |f|
		f.semantic_errors *f.object.errors.keys
		f.inputs "Alterar curso" do
			f.input :nome
			f.input :escolaridade, collection: Escolaridade.where(status: "1").map{|e| [e.nome, e.id]}, include_blank: true
		end
		f.actions
	end

end
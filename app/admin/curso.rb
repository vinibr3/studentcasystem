ActiveAdmin.register Curso do 
	menu priority: 6, parent: "Configurações"
	actions :all

	permit_params :nome, :escolaridade_id, :instituicao_ensino_id

	filter :nome
	filter :escolaridade_id, as: :select, collection: Escolaridade.all.map{|e| [e.nome, e.id]}, include_blank: true
	filter :instituicao_ensino_id, as: :select, collection: InstituicaoEnsino.all.map{|i| [i.nome, i.id]}, include_blank: false

	index do 
		selectable_column
		column :nome
		column "Escolaridade", :escolaridade_nome
		column "Instituição de Ensino", :instituicao_ensino_nome
		actions
	end

	show do 
		panel "Detalhes" do
			attributes_table_for curso do
				row :nome
				row "Escolaridade" do
				 curso.escolaridade_nome
				end
				row "Instituição Ensino" do
					curso.instituicao_ensino_nome
				end
			end
		end
	end

	form do |f|
		f.semantic_errors *f.object.errors.keys
		f.inputs "Alterar curso" do
			f.input :nome
			f.input :escolaridade, collection: Escolaridade.all.map{|e| [e.nome, e.id]}, include_blank: false
			f.input :instituicao_ensino, collection: InstituicaoEnsino.all.map{|i| [i.nome, i.id]}, include_blank: false
		end
		f.actions
	end

end
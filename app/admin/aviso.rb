ActiveAdmin.register Aviso do
	menu priority: 2, parent: "Conteúdo"
	actions :all

	permit_params :aviso

	filter :aviso

	index do
		selectable_column 
		column :aviso
		column :criado_em
		actions
	end

	show do 
		panel "Detalhes" do
			attributes_table_for aviso do
				row :aviso
				row :criado_em
			end
		end
	end

	form do |f|
		f.semantic_errors *f.object.errors.keys
		f.inputs "Texto do Aviso" do
			f.input :aviso
		end
		f.actions
	end
end
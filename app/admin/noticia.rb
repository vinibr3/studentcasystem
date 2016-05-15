ActiveAdmin.register Noticia do 
	menu label: "Notícias", if: proc{current_admin_user.super_admin?}
	permit_params :title, :author, :photo, :body

	filter :titulo
	filter :autor

	index do
		selectable_column
		id_column
		column :titulo
		column :autor
		column :foto_file_name
		column :body
		actions
	end

	show do 
		panel "Dados" do
			attributes_table_for noticia do 
				row :titulo
				row :autor
				row :foto
				row :body
			end
		end
	end

	form do |f|
		f.inputs "Preencha todos os campos" do 
			f.input :titulo
			f.input :autor
			f.input :foto
			f.input :body
		end
		f.actions
	end

end
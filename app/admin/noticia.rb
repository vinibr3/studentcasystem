ActiveAdmin.register Noticia do 
	menu label: "Notícias", if: proc{current_admin_user.super_admin?}, priority: 2, parent: "Conteúdo"
	permit_params :titulo, :autor, :foto, :body

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
				row :foto do
					a noticia.foto_file_name, class: "show-popup-link", href: noticia.foto.url
				end
				row :body
			end
		end
		render inline: "<script type='text/javascript'>$('.show-popup-link').magnificPopup({type: 'image'});</script>"
	end

	form :html => { :enctype => "multipart/form-data"} do |f|
		f.semantic_errors *f.object.errors.keys
		f.inputs "Preencha todos os campos", multipart: true do 
			f.input :titulo
			f.input :autor
			f.input :foto, :hint => "Imagem Atual: #{f.object.foto_file_name}"
			f.input :body
		end
		f.actions
	end

end
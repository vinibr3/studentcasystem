ActiveAdmin.register Evento do 
	menu priority: 1, parent: "Conteúdo"

	permit_params :titulo, :data, :texto, :local, :folder,
				  :url, :text, :title, :rel, :email, :anchor, :alt, :alignment, :scale, :width, :height, :_wysihtml5_mode

	filter :titulo
	filter :local

	index do
		selectable_column
		column :titulo
		column :data
		column :local
		column :folder_nome
		column :data
		actions
	end	

	show do
		panel "Detalhes do Evento" do
			attributes_table_for evento do
				row :titulo
				row :data
				row :local
				row :folder do 
					a evento.folder_file_name, class: "show-popup-link", href: evento.folder.url
				end
				row :texto
				row "Criado em" do
					evento.created_at
				end
			end
		end
		render inline: "<script type='text/javascript'>$('.show-popup-link').magnificPopup({type: 'image'});</script>"
	end

	form do |f|
		f.semantic_errors *f.object.errors.keys
		f.inputs "Detalhes do Evento" do
			f.input :titulo
			f.input :data, as: :datetime_select, datepicker_options: { day_names_min: ["Dom", "Seg", "Ter", "Qua", "Qui", "Sex", "Sáb"],
                                                            month_names_short: ["Jan", "Fev", "Mar", "Abr", "Mai", "Jun", "Jul", "Ago", "Set", "Out", "Nov", "Dez"],
                                                            year_range: "1930:", show_anim: "slideDown", changeMonth: true, changeYear: true}
			f.input :local
			f.input :folder, :hint => "Imagem Atual: #{f.object.folder_file_name}"
			f.input :texto, as: :wysihtml5
		end
		f.actions
	end

end
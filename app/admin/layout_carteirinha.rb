ActiveAdmin.register LayoutCarteirinha do
	menu if: proc{current_admin_user.super_admin?}, priority: 5
	permit_params :anverso, :verso

	filter :anverso_file_name
	filter :verso_file_name

	index do
		selectable_column
    	id_column
    	column :anverso_file_name
    	column :verso_file_name
    	actions
	end

	show do
		panel "Anverso" do
			attributes_table_for layout_carteirinha do
				row :anverso
			end
		end
		panel "Verso" do 
			attributes_table_for layout_carteirinha do
				row :verso
			end
		end
	end

	form do |f| 
		f.inputs "Layouts" do
			f.input :anverso
			f.input :verso
		end
		f.actions
	end

end
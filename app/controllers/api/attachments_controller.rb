class Api::AttachmentsController < Api::AuthenticateBase

	before_action :http_token_authentication

	def show 
		@estudante = Estudante.find(params[:id])
		name = params[:name]
		url = mount_url name
		if url
			if @estudante												
				attachment = {:attachment=>{type: 'url', url: url.as_json}}
				respond_with attachment
			else
				render_erro "Estudante não encontrado.", 404
			end
		else
			render_erro "Attachment '#{name}' não encontrado.", 404
		end
	end

	def update
		@estudante = Estudante.find(params[:id])
		url = mount_url params[:name]
		temp_file = nil				
		if url 
			if @estudante
				file = ''
				begin
					# Cria arquivo temporário
					file_extension = ".".concat(params[:attachment][:format]) 
					decoded = Base64.decode64(params[:attachment][:value])

					# Cria arquivo temporário
					temp_file = Tempfile.new([params[:name],file_extension])
					temp_file.binmode
					temp_file.write(decoded)
					temp_file.rewind
					
					if @estudante.update_attribute(params[:name].to_sym, temp_file)
						render_sucess "Dados salvos com sucesso.", 200
					else
						render_erro "Não foi possível salvar dados.", 501
					end

				rescue Exception => e 

				ensure 
					temp_file.close unless temp_file.nil?
				end
			else
				render_erro "Estudante não encontrado.", 404
			end

		else
			render_erro "Attachment '#{name}' não encontrado.", 404
		end	
	end

	private
		def attachments_params
			params.require(:attachment).permit(:value, :format)
		end

		def mount_url name
			url = ''
			case name 
				when 'foto' 								 then url = @estudante.foto.expiring_url
				when 'comprovante_matricula' then url = @estudante.comprovante_matricula.expiring_url
				when 'xerox_rg' 						 then url = @estudante.xerox_rg.expiring_url
				when 'xerox_cpf' 						 then url = @estudante.xerox_cpf.expiring_url
				else url = nil
			end
			url
		end

end
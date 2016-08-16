class PagesController < ApplicationController
  def index
  	 @avisos = Aviso.all
     @eventos = Evento.all
  end

  def meia_entrada

  end

  def noticias 

  end

  def consulta
    
  end

  def login
  	redirect_to new_estudante_session_path
  end

private
  def page_params
    params.require(:page_params).permit(:codigo_uso)
  end

end
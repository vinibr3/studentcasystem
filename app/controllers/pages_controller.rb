class PagesController < ApplicationController
  def index
  	 
  end

  def meia_entrada

  end

  def noticias 

  end

  def autenticacao
  
  end

  def login
  	redirect_to new_estudante_session_path
  end

end

require 'test_helper'

class EstudanteTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
  test "atributos nao preenchidos" do
  	atributos = estudantes(:vinicius).atributos_nao_preenchidos
  	assert_not atributos.empty? "Há campos a serem preenchidos."
  end

end
require 'test_helper'

class CarteirinhaTest < ActiveSupport::TestCase
  test "ca info generation" do
    Carteirinha.gera_certificado carteirinhas(:carteirinhatest)
    assert true
  end
end

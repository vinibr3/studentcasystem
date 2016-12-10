$(document).ready(function() {

            function limpa_formulário_cep() {
                // Limpa valores do formulário de cep.
                $("#estudante_logradouro").val("");
                $("#estudante_setor").val("");
                $("#estudante_cidade_id").val("");
                $("#estudante_estado").val("");
                $("#estudante_complemento").val("");
                
            }
            
            //Quando o campo cep perde o foco.
            $("#estudante_cep").blur(function() {

                //Nova variável "cep" somente com dígitos.
                var cep = $(this).val().replace(/\D/g, '');

                //Verifica se campo cep possui valor informado.
                if (cep != "") {

                    //Expressão regular para validar o CEP.
                    var validacep = /^[0-9]{8}$/;

                    //Valida o formato do CEP.
                    if(validacep.test(cep)) {

                        //Consulta o webservice viacep.com.br/
                        $.getJSON("//viacep.com.br/ws/"+ cep +"/json/?callback=?", function(dados) {

                            if (!("erro" in dados)) {
                                //Atualiza os campos com os valores da consulta.
                                $("#estudante_logradouro").val(dados.logradouro);
                                $("#estudante_setor").val(dados.bairro);
                                $("#estudante_cidade_id").val(dados.localidade);
                                $("#estudante_estado").val(dados.uf);
                                $("#estudante_complemento").val(dados.complemento);
                            } //end if.
                            else {
                                //CEP pesquisado não foi encontrado.
                                limpa_formulário_cep();
                                alert("CEP não encontrado.");
                            }
                        });
                    } //end if.
                    else {
                        //cep é inválido.
                        limpa_formulário_cep();
                        alert("Formato de CEP inválido.");
                    }
                } //end if.
                else {
                    //cep sem valor, limpa formulário.
                    limpa_formulário_cep();
                }
            });
});
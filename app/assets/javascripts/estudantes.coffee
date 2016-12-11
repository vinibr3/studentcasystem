# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$ ->
  $(document).on 'change', '#estudante_instituicao_ensino', (evt) ->
    $.ajax '/entidades/escolaridades',
      type: 'GET'
      dataType: 'script'
      data: {
        instituicao: $("#estudante_instituicao_ensino option:selected").val()
      }
      error: (jqXHR, textStatus, errorThrown) ->
        console.log("AJAX Error: #{textStatus}")
      success: (data, textStatus, jqXHR) ->
        console.log("Dynamic country select OK!")

  $(document).on 'change', '#estudante_escolaridade', (evt) ->
    $.ajax '/entidades/cursos',
      type: 'GET'
      dataType: 'script'
      data: {
        instituicao: $("#estudante_instituicao_ensino option:selected").val(),
        escolaridade: $("#estudante_escolaridade option:selected").val()
      }
      error: (jqXHR, textStatus, errorThrown) ->
        console.log("AJAX Error: #{textStatus}")
      success: (data, textStatus, jqXHR) ->
        console.log("Dynamic country select OK!")

# Busca Cidade a partir do Estado 
  $(document).on 'change', '#estudante_uf', (evt) ->
    $.ajax '/estados/'+$("#estudante_uf option:selected").val()+'/cidades',
      type: 'GET'
      dataType: 'script'
      error: (jqXHR, textStatus, errorThrown) ->
        console.log("AJAX Error: #{textStatus}")


# Configura endereço a partir do CEP
$(document).ready ->
  #Quando o campo cep perde o foco.

  limpa_formulário_cep = ->
    # Limpa valores do formulário de cep.
    $('#estudante_logradouro').val ''
    $('#estudante_setor').val ''
    #$('#estudante_cidade_id').val ''
    #$('#estudante_uf').val ''
    $('#estudante_complemento').val ''
    return

  $('#estudante_cep').blur ->
    #Nova variável "cep" somente com dígitos.
    cep = $(this).val().replace(/\D/g, '')
    #Verifica se campo cep possui valor informado.
    if cep != ''
      #Expressão regular para validar o CEP.
      validacep = /^[0-9]{8}$/
      #Valida o formato do CEP.
      if validacep.test(cep)
        #Consulta o webservice viacep.com.br/
        $.getJSON '//viacep.com.br/ws/' + cep + '/json/?callback=?', (dados) ->
          if !('erro' of dados)
            #Atualiza os campos com os valores da consulta.
            $('#estudante_logradouro').val dados.logradouro
            $('#estudante_setor').val dados.bairro
            #$('#estudante_cidade_id').val dados.localidade
            #$('#estudante_uf').val dados.uf
            $('#estudante_complemento').val dados.complemento
            $('#estudante_uf option').each ->
              @selected = @text == dados.uf
              return
            # Atualiza cidades-select
            $.ajax '/estados/'+$("#estudante_uf option:selected").val()+'/cidades',
              type: 'GET'
              dataType: 'script'
              async: false
            $('#cidades-select option').each ->
              @selected = @text == dados.localidade
              return          
          else
            #CEP pesquisado não foi encontrado.
            limpa_formulário_cep()
            alert 'CEP não encontrado.'
          return
      else
        #cep é inválido.
        limpa_formulário_cep()
        alert 'Formato de CEP inválido.'
    else
      #cep sem valor, limpa formulário.
      limpa_formulário_cep()
    return
  return
    
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

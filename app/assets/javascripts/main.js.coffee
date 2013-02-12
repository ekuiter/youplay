$(document).on "page:fetch", ->
  $("#loading").show()

$(document).on "page:load", ->
  $("#loading").hide()

ready = ->
  #ready stuff

$(document).ready ready
$(document).on "page:load", ready
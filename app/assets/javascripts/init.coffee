ready = ->
  $(document).on "page:fetch", ->
    $("#loading").show()
  $(document).on "page:load", ->
    $("#loading").hide()
    
  player.init()
  log.init()
  reader.init()
  search.init()
          
$(document).ready ready
$(document).on "page:load", ready
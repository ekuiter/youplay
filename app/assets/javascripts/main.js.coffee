ready = ->
  $(document).on "page:fetch", ->
    $("#loading").show()
  $(document).on "page:load", ->
    $("#loading").hide()
  $("#reader").each ->
    $.ajax("/reader/read").done (data) ->
      $("#loading").show()
      str = "<ul id=\"channels\">"
      $.each data, (k,v) ->
        str += "<li id=\"load_"+v+"\"><span>"+v+"</span></li>"
      $("#reader").append str+"</ul>"
      $.each data, (k,v) ->
        $.ajax("/reader/read/"+v).done (data2) ->
          $("#reader").append data2
          $("#reader #load_"+v).append("&nbsp;&nbsp;✓").children("span").addClass("checked")
          if k == data.length - 1
            $("#loading").hide()
    setTimeout(->
      Turbolinks.visit("/reader/update")
    15*60*1000)
  $("#update").each ->
    $.ajax("/reader/read").done (data) ->
      $("#loading").show()
      str = "<ul id=\"channels\">"
      $.each data, (k,v) ->
        str += "<li id=\"load_"+v+"\"><span>"+v+"</span></li>"
      $("#update").append str+"</ul>"
      $.each data, (k,v) ->
        $.ajax("/reader/update/"+v).done ->
          $("#update #load_"+v).append("&nbsp;&nbsp;✓").children("span").addClass("checked")
          if k == data.length - 1
            $("#loading").hide()
            Turbolinks.visit("/reader/")

$(document).ready ready
$(document).on "page:load", ready
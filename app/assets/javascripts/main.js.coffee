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
          $(".hide").each ->
            hide = $(this)
            row = $(this).parent().parent()
            hide.click ->
              $.ajax(hide.data("url"), type: "delete").done ->
                row.remove()
          if k == data.length - 1
            $("#loading").hide()
            if $("#reader").children().length == 1
              $("#reader").append("<h3>There are no new videos.</h3>")
    setTimeout(->
      Turbolinks.visit("/reader/update")
    15*60*1000)
    
  $("#video_sidebar #favorite").click ->
    img = $("#video_sidebar #favorite :first-child")
    $.ajax(img.data("url"), type: img.data("method")).done ->
      label = $("#video_sidebar #favorite :last-child")
      if img.hasClass("no_favorite")
        img.removeClass("no_favorite").addClass("favorite")
        img.data("method", "delete")
      else
        img.removeClass("favorite").addClass("no_favorite")
        img.data("method", "get")
      text = label.data("text")
      label.data("text", label.text())
      label.text(text)
      
  $(".videos").each ->
    $(".favorite, .no_favorite").each ->
      img = $(this)
      img.click ->
        $.ajax(img.data("url"), type: img.data("method")).done ->
          if img.hasClass("no_favorite")
            img.removeClass("no_favorite").addClass("favorite")
            img.data("method", "delete")
          else
            img.removeClass("favorite").addClass("no_favorite")
            img.data("method", "get")
            
  $("#comments #write_comment button").each ->
    btn = $(this)
    btn.click ->
      btn.text(btn.text().replace(" ✓",""))
      $("#comments #write_comment textarea").each ->
        $.post(document.url, "comment="+$(this).val()).done ->
          btn.text(btn.text()+" ✓")
          
  user_number = 15 
  if $(".ajax-user").length > 0
    times = Math.floor($(".ajax-user").length / user_number)
    for i in [0..times]
      users = []
      $(".ajax-user").slice(i*user_number, (i+1)*user_number).each ->
        users.push($(this).data("user"))
      url = "/channel_info?i=" + i + "&"
      for user in users
        url += "channels[]=" + user + "&"
      $.ajax(url).done (data) ->
        i = data[0]
        j = 1
        $(".ajax-user").slice(i*user_number, (i+1)*user_number).each ->
          $(this).html('<a href="' + data[j]["url"] + '" target="_blank">' + data[j]["username"] + "</a>")
          j++
          
$(document).ready ready
$(document).on "page:load", ready
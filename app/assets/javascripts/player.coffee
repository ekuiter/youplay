window.player =
  prepare: {}

player.init = ->
  player.prepare.favoriteVideo()
  
player.prepare.favoriteVideo = ->
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
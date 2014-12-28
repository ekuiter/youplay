window.player =
  prepare: {}

player.init = ->
  player.prepare.favoriteVideo()
  player.prepare.category()
  player.prepare.share()
  
player.prepare.favoriteVideo = ->
  $("#video_sidebar #favorite").click ->
    icon = $("#video_sidebar #favorite :first-child")      
    $.ajax(icon.data("url"), type: icon.data("method")).done ->
      icon.toggleFavoriteIcon()
      $("#video_sidebar #favorite :last-child").toggleFavoriteLabel()

player.prepare.category = ->
  AjaxForm.category.ajax ->
    category = AjaxForm.category.val("select")
    category = -1 if !category
    "/api/category/#{category}?#{video_id}"

player.prepare.share = ->
  AjaxForm.share.ajax ->
    person = AjaxForm.share.val("select")
    message = AjaxForm.share.val("textarea").replace("\n", " \\n")
    "/api/share/#{person}/?#{video_id}&message=#{message}"

window.log =
  prepare: {}

log.init = ->
  $(".videos").each ->
    log.prepare.favoriteVideos() 
  log.loadUsers()

log.prepare.favoriteVideos = ->
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

log.loadUsers = ->
  user_number = 15
  user_elements = (i) ->
    $(".ajax-user").slice(i*user_number, (i+1)*user_number)
  if $(".ajax-user").length > 0
    times = Math.floor($(".ajax-user").length / user_number)
    for i in [0..times]
      users = []
      user_elements(i).each -> users.push($(this).data("user"))
      url = "/channel?i=#{i}&"
      url += "channels[]=#{user}&" for user in users
      $.ajax(url).done (data) ->
        i = parseInt(data[0])
        j = 1
        user_elements(i).each ->
          $(this).html("<a href=\"#{data[j]["url"]}\" target=\"_blank\">#{data[j]["username"]}</a>")
          j++
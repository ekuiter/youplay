window.log =
  prepare: {}

log.init = ->
  $(".videos").each ->
    log.prepare.favoriteVideos() 
  log.prepare.category()
  log.loadUsers()

log.prepare.favoriteVideos = ->
  $(".favorite, .no_favorite").each ->
    icon = $(this)
    icon.click ->
      $.ajax(icon.data("url"), type: icon.data("method")).done ->
        icon.toggleFavoriteIcon()

log.prepare.category = ->
  $("form.category-all a").click ->
    category = $("form.category-all select").val()
    category = -1 if !category
    window.location.href = "/log/?search=category:#{category}"
  $("form.category").each ->
    $(this).children("select").change ->
      select = $(this)
      options = $(this).children("option")
      selected = $(this).children("option:selected")
      options.each ->
        $(this).text($(this).text().replace(" ✓", ""))
      category = select.val()
      category = -1 if !category
      $.ajax("/api/category/#{category}?#{select[0].id}&token=#{token}").done ->
        selected.text("#{selected.text()} ✓")

log.loadUsers = ->
  user_number = 50
  user_elements = (i) ->
    $(".ajax-user").slice(i*user_number, (i+1)*user_number)
    
  if $(".ajax-user").length > 0
    times = Math.floor($(".ajax-user").length / user_number)
    for i in [0..times]
      users = []
      user_elements(i).each ->
        users.push($(this).data("user"))
        
      url = "/channel?i=#{i}&"
      url += "channels[]=#{user}&" for user in users
      
      $.ajax(url).done (data) ->
        i = parseInt(data[0])
        j = 1
        user_elements(i).each ->
          float = if $(this).parents("#reader").length == 0 then "float: right;" else ""
          $(this).html("
            <a href=\"#{data[j]["url"]}\" target=\"_blank\" style=\"#{float} width: 16px; height: 16px; margin-right: 5px\" class=\"noborder\">
              <img src=\"/assets/newtab.png\" width=\"16\" height=\"16\" />
            </a>
            <a href=\"/log/?search=channel:#{$(this).data("user")}\">#{data[j]["username"]}</a>
          ")
          j++

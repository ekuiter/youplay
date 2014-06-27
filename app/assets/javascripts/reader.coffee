window.reader =
  prepare: {}

reader.init = ->
  $("#reader").each ->
    reader.prepare.refresh(15)
    $("h3 .hide").each ->
      reader.prepare.hideChannel($(this))
    $("td .hide").each ->
      reader.prepare.playOrHideVideo $(this), (element) ->
        $.ajax(element.data("url"), type: "delete")
    $("td .play").each ->
      reader.prepare.playOrHideVideo $(this), ->
    reader.prepare.controls()
  
reader.prepare.hideChannel = (hide) ->
  channel = hide.parent().parent()
  hide.click ->
    $.ajax(hide.data("url"), type: "delete")
    channel.remove()

reader.prepare.playOrHideVideo = (element, clickFunc) ->
  row = element.parent().parent()
  rows = row.parent().children()
  channel = row.parent().parent().parent()
  channels = channel.parent().children()
  element.click ->
    clickFunc(element)
    if rows.length == 1
      if channels.length == 1
        $("#reader").html("<h3>There are no new videos.</h3>")
      else
        channel.remove()
    else
      row.remove()

reader.prepare.refresh = (minutes) ->
  timeout = setTimeout ->
    Turbolinks.visit "/reader"
  , minutes * 60 * 1000
  $(document).on "page:before-change", ->
    clearTimeout(timeout)
    
reader.prepare.controls = ->
  AjaxForm.subscribe.ajax ->
    channel = AjaxForm.subscribe.val("#channel")
    "/api/subscribe/?channel=#{channel}"    
  AjaxForm.hiding_rule.ajax ->
    pattern = AjaxForm.hiding_rule.val("#pattern")
    channel = AjaxForm.hiding_rule.val("#channel")
    "/api/add_hiding_rule/?pattern=#{pattern}&channel=#{channel}"
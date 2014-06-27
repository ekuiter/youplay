window.reader =
  prepare: {}

reader.init = ->
  $("#reader").each ->
    reader.prepare.refresh()
    $("h3 .hide").each ->
      reader.prepare.hideChannel($(this))
    $("td .hide").each ->
      reader.prepare.hideVideo($(this))
    $("td .play").each ->
      reader.prepare.playVideo($(this))
    reader.prepare.controls()
  
reader.prepare.hideChannel = (hide) ->
  channel = hide.parent().parent()
  hide.click ->
    $.ajax(hide.data("url"), type: "delete")
    channel.remove()

reader.prepare.hideVideo = (hide) ->
  row = hide.parent().parent()
  hide.click ->
    $.ajax(hide.data("url"), type: "delete")
    if row.parent().children().length == 1
      if row.parent().parent().parent().parent().children().length == 1
        row.parent().parent().parent().parent().html("<h3>There are no new videos.</h3>")
      else
        row.parent().parent().parent().remove()
    else
      row.remove()

reader.prepare.playVideo = (play) ->
  row = play.parent().parent()
  play.click ->
    if row.parent().children().length == 1
      if row.parent().parent().parent().parent().children().length == 1
        row.parent().parent().parent().parent().html("<h3>There are no new videos.</h3>")
      else
        row.parent().parent().parent().remove()
    else
      row.remove()
      
reader.prepare.refresh = ->
  timeout = setTimeout ->
    Turbolinks.visit "/reader"
  , 15 * 60 * 1000
  $(document).on "page:before-change", ->
    clearTimeout(timeout)
    
reader.prepare.controls = ->
  value_subscribe = $("#subscribe-form #submit").val()
  $("#subscribe-form").submit ->
    $("#subscribe-form #submit").val(value_subscribe)
    channel = $("#subscribe-form #channel").val()
    $.ajax("/api/subscribe/?channel=#{channel}&token=#{token}").done ->
      $("#subscribe-form #submit").val("#{value_subscribe} ✓")
    false
  value_hiding_rule = $("#hiding-rule-form #submit").val()
  $("#hiding-rule-form").submit ->
    $("#hiding-rule-form #submit").val(value_hiding_rule)
    channel = $("#hiding-rule-form #channel").val()
    pattern = $("#hiding-rule-form #pattern").val()
    $.ajax("/api/hiding_rule/?pattern=#{pattern}&channel=#{channel}&token=#{token}").done ->
      $("#hiding-rule-form #submit").val("#{value_hiding_rule} ✓")
    false
window.stats = { charts: { } }

stats.init = ->
  stats.setCollection()
  stats.prepare()

stats.setCollection = ->
  $.urlParam = (name) ->
    results = new RegExp("[?&]" + name + "=([^&#]*)").exec(window.location.href)
    unless results?
      ""
    else
      results[1] or ""
  stats.collection = $.urlParam("search")

stats.prepare = ->
  Chart.defaults.Line.pointDot = false
  Chart.defaults.Line.legendTemplate = "
    <ul class=\"<%=name.toLowerCase()%>-legend\">
      <% for (var i=0; i<datasets.length; i++){%>
      <li>
        <span style=\"background-color:<%=datasets[i].strokeColor%>\"></span>
        <%if(datasets[i].label){%><%=i+1%>. <%=datasets[i].label%><%}%>
      </li>
      <%}%>
    </ul>"

  metrics = ["browsers", "providers", "categories", "channels", "series"]
  metrics.forEach (metric) ->
    stats.doughnut_and_line(metric)

  $("#count").click ->
    $("#count").addClass("active")
    $("#duration").removeClass("active")
    metrics.forEach (metric) ->
        $("##{metric}-count").click()

  $("#duration").click ->
    $("#count").removeClass("active")
    $("#duration").addClass("active")
    metrics.forEach (metric) ->
      $("##{metric}-duration").click()

stats.chart = (canvas, endpoint, callback, duration = false) ->
  if $("##{canvas}").length > 0
    $.ajax("/api/stats/#{endpoint}?search=#{stats.collection}&token=#{token}&duration=#{if duration then "1" else "0"}").done (data) ->
      context = $("##{canvas}").get(0).getContext("2d")
      callback(new Chart(context), data, if duration then "-duration" else "")

stats.doughnut = (canvasGroup) ->
  (chart, data, duration) ->
    canvas = "#{canvasGroup}-doughnut#{duration}"
    stats.charts[canvas] = chart.Doughnut(data)

stats.line = (canvasGroup) ->
  (chart, data, duration) ->
    canvas = "#{canvasGroup}-line#{duration}"
    stats.charts[canvas] = chart = chart.Line(data)
    legend = chart.generateLegend()
    $("##{canvasGroup}-legend#{duration}").html(legend)

stats.doughnut_and_line = (canvasGroup) ->
  stats.chart "#{canvasGroup}-doughnut", "#{canvasGroup}/doughnut", stats.doughnut(canvasGroup)
  stats.chart "#{canvasGroup}-line", "#{canvasGroup}/line", stats.line(canvasGroup)

  $("##{canvasGroup}-count").click ->
    $("##{canvasGroup}-count").addClass("active")
    $("##{canvasGroup}-duration").removeClass("active")
    $(".#{canvasGroup}.count").removeClass("invisible")
    $(".#{canvasGroup}.duration").addClass("invisible")

  $("##{canvasGroup}-duration").click ->
    $("##{canvasGroup}-count").removeClass("active")
    $("##{canvasGroup}-duration").addClass("active")
    $(".#{canvasGroup}.count").addClass("invisible")
    $(".#{canvasGroup}.duration").removeClass("invisible")
    if not stats.charts["#{canvasGroup}-doughnut-duration"]
      stats.chart "#{canvasGroup}-doughnut-duration", "#{canvasGroup}/doughnut", stats.doughnut(canvasGroup), true
      stats.chart "#{canvasGroup}-line-duration", "#{canvasGroup}/line", stats.line(canvasGroup), true

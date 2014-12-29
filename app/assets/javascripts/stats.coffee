window.stats = {}

stats.init = ->
  stats.setCollection()
  stats.prepare()

stats.setCollection = ->
  $.urlParam = (name) ->
    results = new RegExp("[?&]" + name + "=([^&#]*)").exec(window.location.href)
    unless results?
      ""
    else
      results[1] or 0
  stats.collection = $.urlParam("search")

stats.prepare = ->
  Chart.defaults.Line.pointDot = false
  doughnut = (chart, data) ->
    chart.Doughnut(data)
  line = (legendElement) ->
    (chart, data) ->
      legend = chart.Line(data).generateLegend()
      $("##{legendElement}").html(legend)
  stats.chart "browsers-doughnut", "browsers/doughnut", doughnut
  stats.chart "browsers-line", "browsers/line", line("browsers-legend")
  stats.chart "providers-doughnut", "providers/doughnut", doughnut
  stats.chart "providers-line", "providers/line", line("providers-legend")

stats.chart = (canvas, endpoint, callback) ->
  if $("##{canvas}").length > 0
    $.ajax("/api/stats/#{endpoint}?search=#{stats.collection}&token=#{token}").done (data) ->
      context = $("##{canvas}").get(0).getContext("2d")
      callback(new Chart(context), data)


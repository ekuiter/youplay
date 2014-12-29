window.stats = {}

stats.init = ->
  stats.prepare()

stats.prepare = ->
  stats.chart "browsers-doughnut", "browsers_doughnut", (chart, data) ->
    chart.Doughnut(data)
  stats.chart "browsers-line", "browsers_line", (chart, data) ->
    legend = chart.Line(data, { pointDot: false }).generateLegend()
    $("#browsers-legend").html(legend)
  stats.chart "providers-doughnut", "providers_doughnut", (chart, data) ->
    chart.Doughnut(data)
  stats.chart "providers-line", "providers_line", (chart, data) ->
    legend = chart.Line(data, { pointDot: false }).generateLegend()
    $("#providers-legend").html(legend)

stats.chart = (canvas, endpoint, callback) ->
  if $("##{canvas}").length > 0
    $.ajax("/api/stats/#{endpoint}?token=#{token}").done (data) ->
      context = $("##{canvas}").get(0).getContext("2d")
      callback(new Chart(context), data)


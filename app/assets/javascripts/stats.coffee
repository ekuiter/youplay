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
  stats.doughnut_and_line("browsers")
  stats.doughnut_and_line("providers")
  stats.doughnut_and_line("categories")
  stats.doughnut_and_line("channels")
  stats.doughnut_and_line("series")

stats.chart = (canvas, endpoint, callback) ->
  if $("##{canvas}").length > 0
    $.ajax("/api/stats/#{endpoint}?search=#{stats.collection}&token=#{token}").done (data) ->
      context = $("##{canvas}").get(0).getContext("2d")
      callback(new Chart(context), data)

stats.doughnut = (canvasGroup) ->
  canvas = "#{canvasGroup}-doughnut"
  (chart, data) ->
    chart.Doughnut(data)

stats.line = (canvasGroup) ->
  (chart, data) ->
    canvas = "#{canvasGroup}-line"
    chart = chart.Line(data)
    legend = chart.generateLegend()
    $("##{canvasGroup}-legend").html(legend)

stats.doughnut_and_line = (canvasGroup) ->
  stats.chart "#{canvasGroup}-doughnut", "#{canvasGroup}/doughnut", stats.doughnut(canvasGroup)
  stats.chart "#{canvasGroup}-line", "#{canvasGroup}/line", stats.line(canvasGroup)


window.search =
  prepare: {}

search.init = ->
  search.prepare.module()
  search.prepare.submit()
  if search.module == "log"
    engine = search.prepare.engine()
    search.prepare.form(engine)
  $('#search').keyup(() ->
    if $(this).val() == "+++"
      $('.side-controls').addClass('active'))

search.prepare.module = ->
  search.module = if window.location.pathname.indexOf("stats") == -1 then "log" else "stats"
  $("#search-form #search").attr("placeholder", if search.module == "log" then "Search ..." else "Show stats ...")            

search.prepare.submit = ->
  $("#search-form").submit ->
    window.location.href = "/#{search.module}/?search=#{$('#search').val()}"
    false
    
search.prepare.engine = ->
  engine = new Bloodhound
    remote:
      url: "/api/log/%QUERY/0/15?token=#{token}"
      wildcard: "%QUERY"
    prefetch: "/api/log/?token=#{token}"
    datumTokenizer: (d) ->
      Bloodhound.tokenizers.whitespace d.title
    queryTokenizer: Bloodhound.tokenizers.whitespace
    dupDetector: (remote, local) ->
      remote.url == local.url
  engine.initialize()
  engine
  
search.prepare.form = (engine) ->
  $('#search').typeahead null,
    displayKey: "title"
    source: engine.ttAdapter()
    limit: 15
    templates:
      suggestion: (video) ->
        "<a href=\"/play?#{video.provider}:#{video.url}\">
           <em>#{video.channel_topic}</em>
           <div>#{video.title}</div>
        </a>"

window.search =
  prepare: {}

search.init = ->
  search.prepare.submit()
  engine = search.prepare.engine()
  search.prepare.form(engine)
            
search.prepare.submit = ->
  $("#search-form").submit ->
    window.location.href = "/log/?search=#{$('#search').val()}"
    false
    
search.prepare.engine = ->
  engine = new Bloodhound
    limit: 15
    remote: "/api/log/%QUERY/0/15?token=#{token}"
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
    templates:
      suggestion: (video) ->
        "<a href=\"/play?#{video.url}\">
           <em>#{video.channel_topic}</em>
           <div>#{video.title}</div>
        </a>"
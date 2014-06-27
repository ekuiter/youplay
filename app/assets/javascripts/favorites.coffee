$.fn.extend
  toggleFavoriteIcon: ->
    oldState = this.attr("class")
    newState = if oldState == "favorite" then "no_favorite" else "favorite"
    newMethod = if newState == "favorite" then "delete" else "get"
    this.removeClass(oldState).addClass(newState)
    this.data("method", newMethod)
    
  toggleFavoriteLabel: ->
    oldText = this.text()
    newText = this.data("text")
    this.data("text", oldText)
    this.text(newText)
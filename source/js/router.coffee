
define ["utilities"], (Utilities) ->

  class Router extends Utilities

    logging: true

    constructor: ->
      @log "Router::constructor -> #{@getRoute()}"
      @manageRoutes()

    manageRoutes: ->
      switch @getRoute()
        when ""
          @log "Home"
        when "blog"
          @log "Blog"
        when "blog/post"
          @log "Blog Post"
        when "about-us"
          @log "About Us"
        else
          @log "I don't understand this route"


    getRoute: -> location.pathname.substring(1)
    isRoute: (page) -> location.pathname == "/#{page}"
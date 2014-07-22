# Nothing to see here
#= require "jquery/jquery.min"
#= require "requirejs/require"
# // require "foundation/foundation"
# // require "foundation/foundation.topbar"


requirejs.config
  baseUrl: '/javascripts'

require ['utilities', 'router'], (Utilities, Router) ->
  class Main extends Utilities

    logging: false

    constructor: ->
      # @setupFoundation()
      @log "Main::constructor ->"
      @router = new Router()

    setupFoundation: ->
      $(document).foundation
        index : 0
        custom_back_text: true
        back_text: 'Back'
        is_hover: true
        scrolltop : true
        init : false


  $ -> window.Main = new Main()

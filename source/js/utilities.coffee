
define (require) ->

  class Utilities
    constructor: -> console.log "Utilities"

    log: (args...) -> console.log(args) if @logging

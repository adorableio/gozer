PhantomD = require('./phantomDeferred')

class Gozer
  constructor: (options = {}) ->
    @host = options.host || 'localhost'
    @port = options.port || 80

    @baseUrl = "http://#{@host}:#{@port}"
    @page = PhantomD.create().then(PhantomD.createPage)

  visit: (path) ->
    url = @baseUrl + path
    @page = @page.then (page) ->
      PhantomD.open(page, url)
    @

  set: (property, value) ->
    @page.then (page) ->
      page.set(property, value)
    @

  resize: (dimensions) ->
    dimensions.height ?= 768
    @set('viewportSize', dimensions)

  run: (fn, args) ->
    @page.then (page) ->
      PhantomD.evaluate(page, fn, args)

  getStyle: (selector, property) ->
    fn = (args) ->
      [selector, property] = args
      getComputedStyle(document.querySelector(selector)).getPropertyValue(property)

    @run fn, [selector, property]

module.exports = Gozer

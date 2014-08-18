Phantom = require('phantom')
phantomPath = require('phantomjs').path

class Gozer
  constructor: (options = {}) ->
    @host = options.host || 'localhost'
    @port = options.port || 80
    done = options.done || (->)

    @baseUrl = "http://#{@host}:#{@port}"

    Phantom.create (ph) ->
      ph.createPage (page) =>
        @page = page
        done()

  visit: (path, callback) ->
    url = @baseUrl + path
    page.open url, (status) =>
      if status != 'success'
        throw new Error("Cannot connect to #{url}, is the server running?")

      @page = page
      callback(@)

  resize: (dimensions) ->
    dimensions.height ?= 768
    @page.set('viewportSize', dimensions)

  run: (fn, callback, args) ->
    @page.evaluate(fn, callback, args)

  getStyle: (selector, property, callback) ->
    fn = (args) ->
      [selector, property] = args
      getComputedStyle(document.querySelector(selector)).getPropertyValue(property)

    @run fn, callback, [selector, property]

module.exports = Gozer

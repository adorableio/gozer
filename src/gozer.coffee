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

  getStyle: (selector, property, options={}) ->
    fn = (args) ->
      [selector, property] = args
      getComputedStyle(document.querySelector(selector)).getPropertyValue(property)

    @run(fn, [selector, property])
      .then (retrievedProperty) =>
        if property in ['color', 'background-color']
          @_parseColor(retrievedProperty, options)
        else
          retrievedProperty


  _parseColor: (color, options={}) ->
    options.type ?= 'hex'

    if options.type == 'hex' && color.match(/^rgb/)
      @_rgbToHex(color)
    else
      color

  _rgbToHex: (rgbString) ->
    '#' + rgbString
      .replace(/[rgb()]/g, '')
      .split(',')
      .map(Number)
      .map (int) -> int.toString(16)
      .map (hexString) -> "0#{hexString}".slice(-2)
      .join('')
      .toUpperCase()

module.exports = Gozer

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
        if retrievedProperty.match(/^rgb/)
          @_parseColor(retrievedProperty, options)
        else
          retrievedProperty

  _parseColor: (cssValue, options={}) ->
    options.type ?= 'hex'

    return cssValue if options.type != 'hex'

    cssValue
      .match(/[^(]*\([^)]*\)|[^\s]+/g) # tokenize multi-value properties
      .map (value) =>
        if value.match(/^rgb/)
          @_rgbToHex(value)
        else
          value
      .join(' ')

  _rgbToHex: (rgbString) ->
    '#' + rgbString
      .replace(/[rgba()]/g, '')
      .split(',')
      .slice(-3)
      .map(Number) # RGB Ints
      .map (int) -> int.toString(16) # Hex Strings
      .map (hexString) -> "0#{hexString}".slice(-2) # 0-padded
      .join('')
      .toUpperCase()

module.exports = Gozer

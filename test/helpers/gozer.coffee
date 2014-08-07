PhantomD = require('./phantomDeferred')

class Gozer
  constructor: ->
    @page = PhantomD.create().then(PhantomD.createPage)

  visit: (url) ->
    @page = @page.then (page) ->
      PhantomD.open(page, url)
    @

  run: (fn, args) ->
    @page.then (page) ->
      PhantomD.evaluate(page, fn, args)

  resize: (dimensions) ->
    dimensions.height ?= 768
    @page.then (page) ->
      page.set('viewportSize', dimensions)
    @

  getStyle: (selector, property) ->
    fn = (args) ->
      [selector, property] = args
      getComputedStyle(document.querySelector(selector)).getPropertyValue(property)

    @run fn, [selector, property]

module.exports = Gozer

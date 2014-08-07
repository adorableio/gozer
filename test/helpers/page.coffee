PhantomDeferred = require('./phantomDeferred')

class Page
  constructor: ->
    @page = PhantomDeferred.create().then(PhantomDeferred.createPage)

  visit: (url) ->
    @page = @page.then (page) ->
      PhantomDeferred.open(page, url)

  run: (fn, args) ->
    @page.then (page) ->
      PhantomDeferred.evaluate(page, fn, args)

  resize: (dimensions) ->
    dimensions.height ?= 768
    @page.then (page) ->
      page.set('viewportSize', dimensions)

  getStyle: (selector, property) ->
    fn = (args) ->
      [selector, property] = args
      getComputedStyle(document.querySelector(selector)).getPropertyValue(property)

    @run fn, [selector, property]

module.exports = Page

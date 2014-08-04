Gozer = require('./gozer')

class Page
  constructor: ->
    @page = Gozer.create().then(Gozer.createPage)

  visit: (url) ->
    @page = @page.then (page) ->
      Gozer.open(page, url)

  run: (fn, args) ->
    @page.then (page) ->
      Gozer.evaluate(page, fn, args)

  getStyle: (selector, property) ->
    fn = (args) ->
      [selector, property] = args
      getComputedStyle(document.querySelector(selector)).getPropertyValue(property)

    @run fn, [selector, property]

module.exports = Page

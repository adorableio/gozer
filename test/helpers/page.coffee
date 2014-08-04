Gozer = require('./gozer')

class Page
  constructor: ->
    @page = Gozer.create().then(Gozer.createPage)

  visit: (url) ->
    @page = @page.then (page) ->
      Gozer.open(page, url)

  run: (fn) ->
    @page.then (page) ->
      Gozer.evaluate(page, fn)

module.exports = Page

phantom = require('phantom')
Q = require('q')

class Page
  @_createPhantom: ->
    deferred = Q.defer()
    phantom.create (ph) ->
      deferred.resolve(ph)
    deferred.promise

  @_createPage: (ph) ->
    deferred = Q.defer()
    ph.createPage (page, err) ->
      deferred.resolve(page)
    deferred.promise

  @_openPage: (page, url) ->
    deferred = Q.defer()
    page.open url, (status) ->
      deferred.resolve(page)
    deferred.promise

  @_evaluate: (page, fn) ->
    deferred = Q.defer()
    page.evaluate fn, (result) ->
      deferred.resolve(result)
    deferred.promise

  constructor: ->
    @page = Page._createPhantom()
      .then Page._createPage

  visit: (url) ->
    @page = @page.then (page) -> Page._openPage(page, url)

  run: (fn) ->
    @page.then (page) -> Page._evaluate(page, fn)

module.exports = Page

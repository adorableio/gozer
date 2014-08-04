phantom = require('phantom')
Q = require('q')

module.exports =
  create: ->
    deferred = Q.defer()
    phantom.create (ph) ->
      deferred.resolve(ph)
    deferred.promise

  createPage: (ph) ->
    deferred = Q.defer()
    ph.createPage (page, err) ->
      deferred.resolve(page)
    deferred.promise

  open: (page, url) ->
    deferred = Q.defer()
    page.open url, (status) ->
      deferred.resolve(page)
    deferred.promise

  evaluate: (page, fn) ->
    deferred = Q.defer()
    page.evaluate fn, (result) ->
      deferred.resolve(result)
    deferred.promise

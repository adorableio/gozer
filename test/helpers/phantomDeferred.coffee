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
      if status == 'success'
        deferred.resolve(page)
      else
        error = new Error("Cannot connect to #{url}, is the server running?")
        deferred.reject(error)
    deferred.promise

  evaluate: (page, fn, args) ->
    deferred = Q.defer()
    page.evaluate fn, deferred.resolve, args
    deferred.promise

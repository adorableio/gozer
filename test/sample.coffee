expect = require('chai').expect
phantom = require('phantom')

visitUrl = (url, callback) ->
  phantom.create (ph) ->
    ph.createPage (page) ->
      page.open url, (status) ->
        callback(page)

describe 'On page: http://localhost:4567 and', ->
  page = null

  before (done) ->
    visitUrl 'http://localhost:4567', (pg) ->
      page = pg
      done()

  describe 'testing HTML', ->
    it 'retrieves the page title', (done) ->
      page.evaluate (-> document.title), (result) ->
        expect(result).to.equal('MyWay!')
        done()

  describe 'testing CSS', ->
    it 'retrieves computed styles', (done) ->
      page.evaluate (->
        getComputedStyle(document.body).getPropertyValue('font-family')
      ), (result) ->
        expect(result).to.have.string('Helvetica Neue')
        done()

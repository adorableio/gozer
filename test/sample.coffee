expect = require('chai').expect
phantom = require('phantom')

url = 'http://localhost:4567'

describe 'Load page: http://localhost:4567 and', ->
  browser  = null
  testOpts =
    title: 'MyWay!'

  before ->
    browser = new Browser()
    return browser.visit url

  it "is expected to have a title of '#{testOpts.title}'", (done) ->
    expect(browser.text("title")).to.equal(testOpts.title)
    done()

  it "should have a title of '#{testOpts.title}'", (done) ->
    browser.text("title").should.equal(testOpts.title)
    done()

  it "should have a white background on the body", (done) ->
    browser.assert.style('#main', 'background', 'white')
    done()

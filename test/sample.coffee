expect     = require('expect.js')
Browser    = require('zombie')
browser    = new Browser()

url = 'http://localhost:4567'

describe 'Load page: http://localhost:4567 and', ->

  testOpts =
    title: 'MyWay!'
    bodyBackgroundColor: 'white'

  it "is expected to have a title of '#{testOpts.title}'", (done) ->
    browser.visit url, ->
      expect(browser.text('title')).to.equal(testOpts.title)
      done()

  it "should have a title of '#{testOpts.title}'", (done) ->
    browser.visit url, ->
      browser.text("title").should.equal(testOpts.title)
      done()

  it "should have a white background", (done) ->
      browser.visit url, ->
        console.log browser.assert.style('body', 'background')
        browser.assert.style('body', 'background', testOpts.bodyBackgroundColor)
        done()

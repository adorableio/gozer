express = require('express')
Gozer = require('../src/gozer')

startServer = (options = {}) ->
  app = express()
  app.use(express.static(__dirname + '/app'))
  app.listen(options.port || 80)

describe 'Gozer', ->
  gozer = page = null

  before (done) ->
    startServer(port: 3002)
    gozer = new Gozer(port: 3002, done: done)

  beforeEach (done) ->
    gozer.visit '/', (pg) ->
      page = pg
      page.resize(width: '1024')
      done()


  describe 'HTML tests', ->
    it 'can evaluate the document markup', (done) ->
      page.run (->
        document.title
      ), (title) ->
        expect(title).to.equal('Gozer')
        done()

  describe 'CSS tests', ->
    it 'can manually retrieve computed styles', (done)->
      page.run (->
        getComputedStyle(document.body).getPropertyValue('font-family')
      ), (fontFamily) ->
        expect(fontFamily).to.have.string('Helvetica Neue')
        done()

    it 'can retrieve computed styles with a helper', (done) ->
      page.getStyle 'body', 'font-family', (fontFamily) ->
        expect(fontFamily).to.have.string('Helvetica Neue')
        done()

    describe 'breakpoints', ->
      it 'retrieves the computed style', (done) ->
        page.getStyle 'body', 'font-size', (fontSize) ->
          expect(fontSize).to.equal('16px')
          done()

      it 'retrieves the computed style at a different breakpoint', (done) ->
        page.resize(width: 600)

        page.getStyle 'body', 'font-size', (fontSize) ->
          expect(fontSize).to.equal('12px')
          done()

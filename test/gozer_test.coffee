express = require('express')
Gozer = require('../src/gozer')

startServer = (options = {}) ->
  app = express()
  app.use(express.static(__dirname + '/app'))
  app.listen(options.port || 80)

describe 'Gozer', ->
  gozer = page = null

  before ->
    startServer(port: 3002)
    gozer = new Gozer(port: 3002)

  beforeEach ->
    page = gozer
      .visit('/')
      .resize(width: '1024')

  describe 'HTML tests', ->
    it 'can evaluate the document markup', ->
      expect(page.run(-> document.title))
        .to.eventually.equal('Gozer')

  describe 'CSS tests', ->
    it 'can manually retrieve computed styles', ->
      fontFamily = page.run ->
        getComputedStyle(document.body).getPropertyValue('font-family')
      expect(fontFamily)
        .to.eventually.have.string('Helvetica Neue')

    it 'can retrieve computed styles with a helper', ->
      expect(page.getStyle('body', 'font-family'))
        .to.eventually.have.string('Helvetica Neue')

    describe 'breakpoints', ->
      it 'retrieves the computed style', ->
        expect(page.getStyle('body', 'font-size'))
          .to.eventually.equal('16px')

      it 'retrieves the computed style at a different breakpoint', ->
        page.resize(width: 600)

        expect(page.getStyle('body', 'font-size'))
          .to.eventually.equal('12px')

    describe 'retrieving colors', ->
      it 'returns hex strings by default', ->
        expect(page.getStyle('body', 'background-color'))
          .to.eventually.equal('#E7E8EA')

      it 'returns rgb strings if requested', ->
        expect(page.getStyle('body', 'background-color', type: 'rgb'))
          .to.eventually.equal('rgb(231, 232, 234)')

      it 'returns rgba colors as hex', ->
        expect(page.getStyle('body', 'color'))
          .to.eventually.equal('#1E282C')

      it 'parses colors out of more complex properties', ->
        expect(page.getStyle('body', 'text-shadow'))
          .to.eventually.equal('#FFDAB9 1px 2px 3px')

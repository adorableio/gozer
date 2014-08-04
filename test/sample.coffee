Page = require('./helpers/page')

describe 'Gozer', ->
  page = new Page

  beforeEach ->
    page.visit('http://localhost:4567')

  describe 'HTML tests', ->
    it 'can evaluate the document markup', ->
      expect(page.run(-> document.title))
        .to.eventually.equal('MyWay!')

  describe 'CSS tests', ->
    it 'can manually retrieve computed styles', ->
      fontFamily = page.run ->
        getComputedStyle(document.body).getPropertyValue('font-family')
      expect(fontFamily)
        .to.eventually.have.string('Helvetica Neue')

    it 'can retrieve computed styles with a helper', ->
      expect(page.getStyle('body', 'font-family'))
        .to.eventually.have.string('Helvetica Neue')

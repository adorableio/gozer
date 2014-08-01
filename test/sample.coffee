chai = require('chai')
expect = chai.expect
chai.use(require('chai-as-promised'))
Page = require('test/helpers/page')

describe 'On page: http://localhost:4567 and', ->
  page = new Page

  beforeEach ->
    page.visit('http://localhost:4567')

  describe 'the HTML', ->
    it 'has a title', ->
      expect(page.run(-> document.title))
        .to.eventually.equal('MyWay!')

  describe 'the CSS', ->
    describe 'for the body', ->
      it 'has a font-family', ->
        fontFamily = page.run ->
          getComputedStyle(document.body).getPropertyValue('font-family')

        expect(fontFamily).to.eventually.have.string('Helvetica Neue')

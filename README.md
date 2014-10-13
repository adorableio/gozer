# gozer
[![Build Status](https://travis-ci.org/adorableio/gozer.svg?branch=master)](https://travis-ci.org/adorableio/gozer)

![Gozer](https://raw.githubusercontent.com/wiki/adorableio/gozer/images/gozer.png)

gozer is a phantomJS wrapper. It can do normal phantomJS stuff, using promises:

```javascript
var Gozer = require('gozer');

// Load an instance pointed at http://localhost:3000
var gozer = new Gozer({port: 3000});

// Get a page
var page = gozer.visit('/');

// Do some stuff with the page
page
  .run(function() {
    return document.title;
  })
  .then(function(title) {
    console.log('The page title is', title);
  });
```

but that's not why we built it. We built gozer to _test our CSS_, so it really shines when it's used in a test framework.
Here's an example using [mocha](http://visionmedia.github.io/mocha/) and [chai-as-promised](https://github.com/domenic/chai-as-promised/):

```javascript
var Gozer = require('gozer');

describe('google.com', function() {
  var gozer, page;

  before(function() {
    gozer = new Gozer({host: 'google.com'});
  });

  describe('the homepage', function() {
    beforeEach(function() {
      page = gozer.visit('/');
    });

    it('uses the arial font', function() {
      var fontPromise = page.getStyle('body', 'font-family');

      return expect(fontPromise).to.eventually.have.string('arial');
    });
  });
});
```

For more examples, check out [gozer's own tests](test/).

### Installation and Setup

Gozer is meant to be used as a node module, so it's as simple as

    npm install gozer

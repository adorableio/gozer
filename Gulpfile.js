
// Gulpfile.js
// Require the needed packages
var gulp         = require('gulp'),
    browserify   = require('gulp-browserify'),
    ejs          = require('gulp-ejs'),
    mocha        = require('gulp-mocha'),
    gutil        = require('gulp-util'),
    rename       = require('gulp-rename'),
    stylus       = require('gulp-stylus'),
    path         = require('path'),
    colors       = require('colors');

var del, livereload, runSequence;

if (process.env.NODE_ENV == "development") {
  del         = require('del'),
  runSequence = require('run-sequence');
}

var baseAppPath = path.join(__dirname, 'app'),
    baseStaticPath = path.join(__dirname, '.generated'),
    baseJsPath = path.join(baseAppPath, 'js'),
    baseCssPath = path.join(baseAppPath, 'css');

var paths = {
  cssInput: path.join(baseCssPath, 'main.styl'),
  cssOutput: path.join(baseStaticPath, 'css'),
  coffeeInput: path.join(baseJsPath, 'app.coffee'),
  coffeeOutput: path.join(baseStaticPath, 'js'),
  cleanPath: path.join(baseStaticPath, '**', '*'),
  ejsPath:  [path.join(baseAppPath, '**', '*.ejs')],
  assetsBasePath: baseAppPath,
  assetsPaths: [
    path.join(baseAppPath, 'img', '**', '*'),
    path.join(baseAppPath, 'fonts', '**', '*'),
    path.join(baseAppPath, '**', '*.html')
  ],
  assetsOutput: baseStaticPath
};

var watchPaths = {
  css: [
    path.join(baseCssPath, '**', '*.styl*'),
    baseCssPath, path.join('**', '*', '*.styl*')
  ],
  coffee: [path.join(baseJsPath, '**', '*.coffee')],
  assets: paths.assetsPaths,
  ejs: paths.ejsPath
}


//
// Test
//
var testFiles = ['test/sample.coffee'];

gulp.task('test', function() {
  // NOTE: gulp-mocha does not check mocha.opts, so defining opts manually
  return gulp.src(testFiles, { read: false })
    .pipe(mocha({
      compilers: 'coffee:coffee-script',
      timeout: '20s',
      reporter: 'spec',
      ui: 'bdd',
      globals: {
        should: require('should'),
        coffee: require('coffee-script/register'),
        helper: require('./test/test_helper')
      }
  }));
});


//
// Stylus
//
// Get and render all .styl files recursively
gulp.task('stylus', function () {
  return gulp.src(paths.cssInput)
    .pipe(stylus()
      .on('error', gutil.log)
      .on('error', gutil.beep))
    .pipe(gulp.dest(paths.cssOutput));
});


//
// Coffee
//
gulp.task('coffee', function() {
  return gulp.src(paths.coffeeInput, { read: false })
    .pipe(browserify({
      basedir: __dirname,
      transform: ['coffeeify'],
      extensions: ['.coffee']
    }).on('error', gutil.log)
      .on('error', gutil.beep))
    .pipe(rename('app.js'))
    .pipe(gulp.dest(paths.coffeeOutput));
});


//
// EJS
//
gulp.task('ejs', function() {
  return gulp.src(paths.ejsPath)
    .pipe(ejs()
      .on('error', gutil.log)
      .on('error', gutil.beep))
    .pipe(gulp.dest(paths.assetsOutput));
});


//
// Static Assets
//
gulp.task('assets', function() {
  return gulp.src(paths.assetsPaths, {base: paths.assetsBasePath})
    .on('error', gutil.log)
    .on('error', gutil.beep)
    .pipe(gulp.dest(paths.assetsOutput));
});


//
// clean
//

gulp.task('clean', function() {
  return del(paths.cleanPath, { sync: true });
});


//
// Watch pre-tasks
//

gulp.task('watch-pre-tasks', function(callback) {
  runSequence('clean', ['coffee', 'stylus', 'assets', 'ejs'], callback);
});

//
// Watch
//
gulp.task('watch', function(callback) {

  gulp.watch(watchPaths.css, ['stylus'])
    .on('error', gutil.log)
    .on('error', gutil.beep);
  gulp.watch(watchPaths.coffee, ['coffee'])
    .on('error', gutil.log)
    .on('error', gutil.beep);
  gulp.watch(watchPaths.assets, ['assets'])
    .on('error', gutil.log)
    .on('error', gutil.beep);
  gulp.watch(watchPaths.ejs, ['ejs'])
    .on('error', gutil.log)
    .on('error', gutil.beep);

});

gulp.task('default', ['stylus', 'coffee', 'assets', 'ejs']);

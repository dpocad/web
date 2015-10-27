'use strict'
# generated on 2015-05-06 using generator-gulp-webapp 0.3.0
gulp = require 'gulp'
$ = (require 'gulp-load-plugins')()
browserSync = require 'browser-sync'
reload = browserSync.reload
url = require 'url'
pkg = require './package.json'

gulp.task 'styles', ->
  gulp.src('app/styles/main.scss').pipe($.sourcemaps.init()).pipe($.sass(
    outputStyle: 'nested'
    precision: 10
    includePaths: [ '.' ]
    onError: console.error.bind(console, 'Sass error:'))).pipe($.postcss([ require('autoprefixer-core')(browsers: [ 'last 1 version' ]) ])).pipe($.sourcemaps.write()).pipe(gulp.dest('.tmp/styles')).pipe reload(stream: true)


gulp.task 'jshint', ->
  gulp.src('app/scripts/**/*.js').pipe(reload(
    stream: true
    once: true)).pipe($.jshint()).pipe($.jshint.reporter('jshint-stylish')).pipe $.if(!browserSync.active, $.jshint.reporter('fail'))


gulp.task 'html', [
  'styles'
  'views'
], ->
  assets = $.useref.assets(searchPath: [
    '.tmp'
    'app'
    '.'
  ])
  gulp.src([
    'app/*.html'
    '.tmp/*.html'
  ]).pipe(assets).pipe($.if('*.js', $.uglify())).pipe($.if('*.css', $.csso())).pipe(assets.restore()).pipe($.useref()).pipe($.if('*.html', $.minifyHtml(
    conditionals: true
    loose: true))).pipe gulp.dest('dist')


gulp.task 'images', ->
  gulp.src('app/images/**/*').pipe($.cache($.imagemin(
    progressive: true
    interlaced: true
    svgoPlugins: [ { cleanupIDs: false } ]))).pipe gulp.dest('dist/images')


gulp.task 'fonts', ->
  gulp.src(require('main-bower-files')(filter: '**/*.{eot,svg,ttf,woff,woff2}').concat('app/fonts/**/*')).pipe(gulp.dest('.tmp/fonts')).pipe gulp.dest('dist/fonts')


gulp.task 'extras', ->
  gulp.src([
    'app/CNAME'
    'app/*.*'
    '!app/*.html'
    '!app/*.jade'
  ], dot: true).pipe gulp.dest('dist')


gulp.task 'clean', require('del').bind(null, [
  '.tmp'
  'dist'
])


gulp.task 'views', ->
  gulp.src('app/*.jade').pipe($.jade(pretty: true)).pipe gulp.dest('.tmp')


gulp.task 'serve', [
  'styles'
  'fonts'
  'views'
], ->
  browserSync
    notify: false
    port: 9000
    server:
      baseDir: [
        '.tmp'
        'app'
      ]
      routes: '/bower_components': 'bower_components'
  # watch for changes
  gulp.watch([
    'app/*.html'
    '.tmp/*.html'
    'app/scripts/**/*.js'
    'app/images/**/*'
    '.tmp/fonts/**/*'
  ]).on 'change', reload
  gulp.watch 'app/**/*.jade', [ 'views' ]
  gulp.watch 'app/styles/**/*.scss', [ 'styles' ]
  gulp.watch 'app/fonts/**/*', [ 'fonts' ]
  gulp.watch 'bower.json', [
    'wiredep'
    'fonts'
  ]
  return


# inject bower components
gulp.task 'wiredep', ->
  wiredep = require('wiredep').stream
  gulp.src('app/styles/*.scss').pipe(wiredep(ignorePath: /^(\.\.\/)+/)).pipe gulp.dest('app/styles')
  gulp.src('app/layouts/*.jade').pipe(wiredep(
    exclude: []
    ignorePath: /^(\.\.\/)*\.\./)).pipe gulp.dest('app/layouts')
  return


gulp.task 'build', [
  'jshint'
  'html'
  'images'
  'fonts'
  'extras'
], ->
  gulp.src('dist/**/*').pipe $.size(
    title: 'build'
    gzip: true)

gulp.task 'deploy', ['build'], () ->
  remoteUrl = url.parse pkg.repository.url
  # Add travis secure to remote url
  options =
    remoteUrl: "#{remoteUrl.protocol}//#{process.env.GH_TOKEN}@#{remoteUrl.host}#{remoteUrl.pathname}"
  gulp.src './dist/**/*'
    .pipe ($.ghPages options)

gulp.task 'default', [ 'clean' ], ->
  gulp.start 'build'
  return

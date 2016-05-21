////////////////////////////
// Loding Gulp and Plugins
////////////////////////////
var gulp            = require('gulp'),
    plugins         = require('gulp-load-plugins')({pattern: '*'}),
    railsEnv        = process.env.RAILS_ENV || 'development';

gulp.task('default', plugins.sequence('clean',['images', 'coffee', 'sass', 'fonts'], 'watch'));
gulp.task('live', plugins.sequence('clean', ['images', 'coffee'], ['sass', 'fonts'], 'production'));

///////////////////
// Clean Assets Task
///////////////////

gulp.task('clean', function (cb) {
    plugins.del(['./public/stylesheets'], cb);
    plugins.del(['./public/javascripts'], cb);
    plugins.del(['./public/images'], cb);
    plugins.del(['./public/fonts'], cb);
    cb();
});


///////////////////
// ReactJs(JSX) Task
///////////////////

gulp.task('react', function(cb) {
    return plugins.browserify({
        entries: ['./app/frontend/index.js'],
        extensions: ['.js', '.jsx'],
        debug: railsEnv === 'development'
    })
    .transform(plugins.babelify.configure({
        presets : ['es2015', 'react', 'stage-0']
    }))
    .bundle()
    .pipe(source('bundle.js'))
    .pipe(gulp.dest('public/javascripts'));

});

////////////////////////
// Js Task
////////////////////////
var coffeeFilter;
coffeeFilter = plugins.filter(['**/*.coffee', '**/*.js'], {restore: true});

var bundleCoffee, coffeeStream, transformCoffee;
coffeeStream = plugins.browserify({
    entries: ['app/assets/javascripts/application.js'],
    extensions: ['.coffee','.js'],
    debug: railsEnv === 'development'
});

transformCoffee = function(stream) {
    return stream.transform('coffeeify').transform('uglifyify');
};

bundleCoffee = function(stream) {
    return stream.bundle().pipe(plugins.vinylSourceStream('application.js')).pipe(gulp.dest('public/javascripts')).pipe(plugins.livereload());
};

gulp.task('coffee', function(cb) {
    return bundleCoffee(transformCoffee(coffeeStream));
});

////////////////////////
// SASS Task
////////////////////////
gulp.task('sass', function(cb) {
    var stream;
    stream = gulp.src('app/assets/stylesheets/application.scss').pipe(plugins.sourcemaps.init()).pipe(plugins.sass({
        includePaths: 'path/to/code',
        sourceComments: true,
        outputStyle: 'compressed',
        errLogToConsole: true
    })).pipe(plugins.autoprefixer()).pipe(plugins.rename('application.css'));
    if (['production', 'staging'].indexOf(railsEnv) !== -1) {
        stream = stream.pipe(plugins.cleanCss());
    }
    return stream.pipe(gulp.dest('./public/stylesheets')).pipe(plugins.sourcemaps.write('.')).pipe(plugins.livereload());
});


////////////////////////
// Images Task
////////////////////////
gulp.task('images', function(cb) {
    var srcPath  = './app/assets/images/**',
        destPath = './public/images';

    return gulp.src(srcPath)
        .pipe(plugins.changed(destPath)) // Ignore unchanged files
        .pipe(gulp.dest(destPath)); // Write images to public dir
});


////////////////////////
// Fonts Task
////////////////////////
gulp.task('fonts', function(cb) {
    var srcPath  = './app/assets/fonts/**',
        destPath = './public/fonts';

    return gulp.src(srcPath)
        .pipe(plugins.changed(destPath)) // Ignore unchanged files
        .pipe(gulp.dest(destPath)); // Write images to public dir
});

////////////////////////
// Production Task
// for digest/revisions
////////////////////////
gulp.task('production', function() {
    var revAll = new plugins.revAll();
    return gulp.src(['./public/stylesheets/**','./public/javascripts/**', './public/images/**', './public/fonts/**'])
        .pipe(revAll.revision())
        .pipe(gulp.dest('public'))
        .pipe(revAll.manifestFile())
        .pipe(gulp.dest('public'));
});


////////////////////////
// Watch Task
////////////////////////
gulp.task('watch', function(callback) {
    plugins.watch("app/assets/stylesheets/**/*", function() { gulp.start('sass'); });
    plugins.watch("app/assets/javascripts/**/*", function() { gulp.start('coffee'); });
    plugins.watch("app/assets/images/**/*", function() { gulp.start('images'); });
    plugins.watch("app/assets/fonts/**/*", function() { gulp.start('fonts'); });
});
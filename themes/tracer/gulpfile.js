var gulp     = require("gulp"),
    concat   = require("gulp-concat"),
    sass     = require("gulp-sass"),
    hash     = require("gulp-hash"),
    prefixer = require("gulp-autoprefixer"),
    uglify   = require("gulp-uglify"),
    del      = require("del");

var SRCS = {
  scss: ["source/scss/style.scss"],
  scssWatch: ["source/scss/**/*.scss"],
  js: ["node_modules/anchor-js/anchor.js", "source/js/app.js"]
}

gulp.task('sass', (done) => {
  del(['static/css/style-*.css']);

  gulp.src(SRCS.scss)
    .pipe(sass({
      outputStyle: 'compressed'
    }).on('error', sass.logError))
    .pipe(hash())
    .pipe(prefixer({
			browsers: ['last 2 versions'],
			cascade: false
		}))
    .pipe(gulp.dest('static/css'))
    .pipe(hash.manifest('assetHashes.json'))
    .pipe(gulp.dest('data'));
  done();
});

gulp.task('sass:watch', () => {
  gulp.watch(SRCS.scssWatch, gulp.series('sass'));
});

gulp.task('js', (done) => {
  del(['static/js/app-*.js']);

  gulp.src(SRCS.js)
    .pipe(concat("app.js"))
    .pipe(uglify())
    .pipe(hash())
    .pipe(gulp.dest('static/js'))
    .pipe(hash.manifest('assetHashes.json'))
    .pipe(gulp.dest('data'));

  done();
});

gulp.task('js:watch', () => {
  gulp.watch(SRCS.js, gulp.series('js'));
});

gulp.task('build', gulp.series('sass', 'js'));

gulp.task('dev', gulp.series('sass', 'js', gulp.parallel('sass:watch', 'js:watch')));

gulp.task('default', gulp.series('dev'));

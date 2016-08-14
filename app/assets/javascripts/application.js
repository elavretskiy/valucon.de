// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require oxymoron/underscore
//= require oxymoron/angular
//= require oxymoron/angular-sanitize
//= require oxymoron/angular-animate
//= require oxymoron/angular-resource
//= require oxymoron/angular-cookies
//= require oxymoron/angular-ui-router
//= require oxymoron/ng-notify
//= require oxymoron
//= require angular-translate
//= require angular-translate
//= require angular-translate-storage-cookie
//= require angular-translate-storage-local
//= require angular-translate-loader-static-files
//= require angular-translate-handler-log
//= require paging
//= require angular-ui-bootstrap
//= require angular-ui-bootstrap-tpls
//= require angularjs-file-upload
//= require jquery
//= require jquery_ujs
//= require bootstrap-sprockets
//= require app
//= require_self
//= require_tree .

var app = angular.module('app', ['ui.router', 'oxymoron', 'bw.paging',
    'ngSanitize', 'pascalprecht.translate', 'ui.bootstrap', 'angularFileUpload']);

app.config(['$stateProvider', function ($stateProvider) {
  $stateProvider.rails();
}]);

angular.module('oxymoron.notifier', []).run [
  '$rootScope'
  'ngNotify'
  'Validate'
  '$state'
  '$http'
  '$location'
  ($rootScope, ngNotify, Validate, $state, $http, $location) ->

    callback = (type, res) ->
      $('.loading').hide()

      if res.data and angular.isObject(res.data)
        if res.data.msg
          ngNotify.set res.data.msg, type
        if res.data.errors
          Validate res.data.form_name or res.config.data.form_name, res.data.errors
        if res.data.redirect_to_url
          $location.url res.data.redirect_to_url
        else if res.data.redirect_to
          $state.go res.data.redirect_to, res.data.redirect_options or {}
        if res.data.reload
          window.location.reload()
      return

    ngNotify.config
      theme: 'pure',
      position: 'top',
      duration: 3000,
      type: 'info',
      sticky: false,
      button: true,
      html: true

    $rootScope.$on 'loading:finish', (h, res) ->
      callback 'success', res
      return
    $rootScope.$on 'loading:error', (h, res, p) ->
      callback 'error', res
      return
    return
]

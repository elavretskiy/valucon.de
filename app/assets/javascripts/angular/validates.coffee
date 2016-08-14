angular.module('oxymoron.services.validate', []).factory 'Validate', [ ->
  (form, errors) ->
    $form
    $form
    try
      $form = angular.element(document.querySelector('[name="' + form + '"]')).scope()[form]
    catch e
      $form = {}
    angular.element(document.querySelectorAll('.rails-errors')).remove()
    angular.element(document.querySelectorAll('.form-group')).removeClass('has-error')
    angular.forEach $form, (ctrl, name) ->
      if name.indexOf('$') != 0
        angular.forEach ctrl.$error, (value, name) ->
          ctrl.$setValidity name, null
          return
      return
    angular.forEach errors, (errors_array, key) ->
      form_key = form + '[' + key + ']'
      try
        if $form[form_key]
          $form[form_key].$setTouched()
          $form[form_key].$setDirty()
          $form[form_key].$setValidity 'server', false
        angular.element(document.querySelector('[name="' + form_key + '"]').closest('.form-group')).addClass('has-error')
        angular.element(document.querySelector('[name="' + form_key + '"]')).parent().append '<div class="rails-errors" ng-messages="' + form_key + '.$error"><span class="help-block" ng-message="server">' + errors_array[0] + '</span></div>'
      catch e
        console.log e
        console.warn 'Element with name ' + form_key + ' not found for validation.'
      return
    return
]

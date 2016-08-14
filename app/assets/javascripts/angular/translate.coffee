app.config ['$httpProvider', '$translateProvider', ($httpProvider, $translateProvider) ->
  $translateProvider.useStaticFilesLoader
    prefix: '/assets/locales/'
    suffix: '.json'
  $translateProvider.preferredLanguage('ru')
  $translateProvider.fallbackLanguage('ru')
  $translateProvider.useLocalStorage()
  $translateProvider.useMissingTranslationHandlerLog()
  $translateProvider.useSanitizeValueStrategy(null)
]

app.controller 'TaskUploadsController', [
  '$scope'
  'FileUploader'
  '$attrs'
  ($scope, FileUploader, $attrs) ->
    $scope.uploader = new FileUploader(
      url: '/admin/uploads/tasks',
      formData: [
        { task_id: $attrs.id },
        { authenticity_token: $attrs.token }
      ]
    )
]

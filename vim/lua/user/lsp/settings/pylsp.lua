return {
  settings = {
    pylsp = {
      plugins = {
        pycodestyle = {
          ignore = {'E501', 'W503'},
          maxLineLength = 100,
          enabled = false
        },
        pyflakes = {
          enabled = true
        }
      },
      jedi_completion = {
        enabled = true,
        eager = true,
        cache_for = {'aws_cdk'},
        include_function_objects = true,
        include_class_objects = true,
        include_params = true
      }
    }
  }
}

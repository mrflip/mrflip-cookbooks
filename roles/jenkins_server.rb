name        'jenkins'
description 'installs jenkins'

run_list *%w[
  jenkins
  ]

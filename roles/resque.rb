name        'resque'
description 'installs resque'

run_list *%w[
  redis::base
  redis::install_from_package
  resque
  ]

package { 'npm':
  ensure   => installed,
}

package { 'grunt-cli':
  ensure   => installed,
  provider => npm,
  require  => Package['npm'],
}

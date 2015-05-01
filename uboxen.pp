class bash {
  package { [ 'bash', 'bash-completion', 'command-not-found' ] :
    ensure => latest,
  }
}

node generic_host {

  # General DEFAULTS
  Exec { path => "/usr/bin:/usr/sbin/:/bin:/sbin" }

  include apt

  # Common utilities
  $common_packages = [
    'ack-grep',
    'curl',
    'fdupes',
    'google-chrome-stable',
    'ipcalc',
    'ngrep',
    'nmap',
    'python-pip',
    'python-virtualenv',
    'pwgen',
    'tcpdump',
  ]
  package { $common_packages : ensure => latest }
}

# java
#http://www.webupd8.org/2012/09/install-oracle-java-8-in-ubuntu-via-ppa.html
# dropbox
# sudo apt-get install dropbox python-gpgme
# hipchat
# mumble

# chrome
#   sudo add-apt-repository "deb http://dl.google.com/linux/chrome/deb/ stable main"
#   wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo apt-key add -
#   sudo apt-get update
#  sudo aptitude install google-chrome-stable

apt::source { 'google-chrome-stable':
  comment  => 'google chrome stable repo',
  location => 'http://dl.google.com/linux/chrome/deb/',
  release  => 'stable',
  key      => '7FAC5991',
  notify   => Package ['google-chrome-stable'],
}

node generic_desktop inherits generic_host {

  include vagrant

  package { 'skype':
    require => Apt::Source['canonical-partner'],
  }

  apt::source { 'canonical-partner':
    location  => 'http://archive.canonical.com/ubuntu',
    repos     => 'partner',
  }

  # Google
  #apt::source { 'google-chrome':
  #  location  	=> 'http://dl.google.com/linux/chrome/deb/',
  #  release   	=> 'stable',
  #  key           => '7FAC5991',
  #}
  #apt::source { 'google-talkplugin':
  #  location  	=> 'http://dl.google.com/linux/talkplugin/deb/',
  #  release   	=> 'stable',
  #  key           => '7FAC5991',
  #}
}


class vagrant {
  package { 'virtualbox-nonfree': ensure	=> latest }
  package { 'vagrant': 		    ensure	=> latest }
  }

node default inherits generic_desktop {

  $unix_user = 'jbruce'
  $unix_home = "/home/${unix_user}"
  $email     = 'jbruce12000@gmail.com'

  include git

  git::config { 'user.name': value => $unix_user, }
  git::config { 'user.email': value => $email, }

  user { $unix_user :
    groups => [ 'adm', 'sudo', 'wheel' ],
  }

  vim::rc { 'set tabstop=2': }
  vim::rc { 'set shiftwidth=2': }
  vim::rc { 'set expandtab': }
  vim::rc { 'set pastetoggle=<F6>': }

  package { [ 'ruby-dev', 'ruby-hiera' ] : ensure => present }
  package { [ 'puppet-lint', 'puppet-syntax', 'librarian-puppet', 'rspec-puppet', 'puppetlabs_spec_helper']:
    provider => 'gem',
    ensure   => 'present',
  }
}

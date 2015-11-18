	class exmodule::apache {

	    # Ensure Time Zone and Region.
		class { 'timezone':
			timezone => 'Europe/Madrid',
		}

		#NTP
		class { '::ntp':
			server => [ '1.es.pool.ntp.org', '2.europe.pool.ntp.org', '3.europe.pool.ntp.org' ],
	}
		firewalld_rich_rule { 'Accept HTTP':
	      ensure  => present,
	      zone    => 'public',
	      service => 'http',
	      action  => 'accept',
	    }

		file {'/var/www/myproject/index.php':
			ensure => 'file',
			path => '/var/www/myproject/index.php',
			mode => '1777',
			owner => 'root',
			group => 'root',
			content => "Hello World. Sistema operativo $kernel $operatingsystemrelease",
			require => File['/var/www/myproject']
		}

		file {'/var/www/myproject/info.php':
			ensure => 'file',
			path => '/var/www/myproject/info.php',
			mode => '1777',
			owner => 'root',
			group => 'root',
			content => "<?php phpinfo();",
			require => File['/var/www/myproject']
		}

		file {'/var/www/myproject':
			ensure => 'directory',
			path => '/var/www/myproject',
			mode => '1777',
			owner => 'root',
			group => 'root',
			before => Class['apache']
		}

		# APACHE
		class{ 'apache': }

		apache::vhost { 'myMpwar.prod':
			port    => '80',
			docroot       => '/var/www/myproject',
		}

		apache::vhost { 'myMpwar.dev':
			port    => '80',
			docroot       => '/var/www/myproject',
		}

		include apache::mod::php

		
		# PHP
		include ::yum::repo::remi
		package { 'libzip-last':
			require => Yumrepo['remi']
		}

		class{ '::yum::repo::remi_php56':
			require => Package['libzip-last']
		}

		class { 'php':
			version => 'latest',
			require => Yumrepo['remi-php56'],
		}

	}
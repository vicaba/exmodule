class exmodule {

	class{'exmodule::apache':}

	class {'exmodule::mysql':}

	class{'exmodule::mongo':}




	class exmodule::apache {

		include exmodule::time

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

	class exmodule::mysql {

		# MYSQL
	  	class { '::mysql::server':}
		  	mysql::db { 'mympwar':}
		      user     => 'vagrant',
		      password => 'vagrant'
		  	}

		  	mysql::db { 'mpwar_test':
		      user     => 'vagrant',
		      password => 'vagrant'
		  	}

		  	#FIREWALL
		  	firewalld_rich_rule { 'Accept HTTP':
		      ensure  => present,
		      zone    => 'public',
		      service => 'http',
		      action  => 'accept',
		    }
	  	}

	  	include exmodule::time

	}


  	class exmodule::time {
	    # Ensure Time Zone and Region.
		class { 'timezone':
			timezone => 'Europe/Madrid',
		}

		#NTP
		class { '::ntp':
			server => [ '1.es.pool.ntp.org', '2.europe.pool.ntp.org', '3.europe.pool.ntp.org' ],
	}
  	}


	class exmodule::mongo {
	  	include exmodule::time



	# MONGO DB (no va)
	# class {'::mongodb::server':
  	# 	port    => 27018,
  	# 	verbose => true,
	# }

	# class {'::mongodb::client':}

	}



}
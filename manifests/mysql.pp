	class exmodule::mysql {

		    # Ensure Time Zone and Region.
		class { 'timezone':
			timezone => 'Europe/Madrid',
		}

		#NTP
		class { '::ntp':
			server => [ '1.es.pool.ntp.org', '2.europe.pool.ntp.org', '3.europe.pool.ntp.org' ],
	}

		# MYSQL
	  	class { '::mysql::server':}

		  	mysql::db { 'mympwar':
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
	class exmodule::mysql {


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


	  	}
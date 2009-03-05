#!perl -T

use Test::More tests => 4;

BEGIN {
	use_ok( 'Lingua::EN::Scansion' );
	use_ok( 'Lingua::EN::Scansion::Word' );
	use_ok( 'Lingua::EN::Scansion::Syllable' );
	use_ok( 'Lingua::EN::Scansion::Line' );
}

diag( "Testing Lingua::EN::Scansion $Lingua::EN::Scansion::VERSION, Perl $], $^X" );

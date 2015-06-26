#! /usr/bin/env perl

#
# OpSys package - to determine operating system
# =============================================
#
# Pretty hackish, but will enable determining rhel versions
# and so, is good for my needs for now.
#
# $Id$
#

# package imports
# ===============

package OpSys;

$VERSION = 1.00;

use strict;
use warnings;

use Config;

# subroutine declarations
# =======================

sub _guessdistro;

sub new;
sub dump;
sub main;

# subroutines
# ===========

# _guessdistro:
#
# try to guess distribution via kernel revision ...
# there is also 'Linux::Distribution', which is probably better
#
# example from RHEL6 (actually SL6)
#
# operating system: linux
# osname: linux
# osvers: 2.6.32-358.23.2.el6.x86_64
# archname: x86_64-linux-thread-multi
#
# set: { kvers => 2.6.32-358.23.2 , distro => el, distvers => 6 }
#

sub _guessdistro {
	my $me = shift;

	my $osname = $me->{osname};
	my $osvers = $me->{osvers};
	my $archname = $me->{archname};

	my ($archhw,$kvers,$distro,$distvers);

	($archhw = $archname ) =~ s:-.*::;
	$me->{archhw} = $archhw;

	if($osname eq 'linux') {

		$kvers = $osvers;
		$distro = 'unknown';
		$distvers = 'unknown';


		if ( $osvers =~ m:(.*)\.(.*?)\.$archhw$: ) {
		
			$kvers = $1;
			my $distrev = $2;

			if ( $distrev =~ m:^(\w+)(\d+): ) {
				$distro = $1;
				$distvers = $2;
			}

		}

		$me->{kvers} = $kvers;
		$me->{distro} = $distro;
		$me->{distvers} = $distvers;

	}

}

sub new {
	my $class = shift;
	my $me = {};

	$me->{osname} = $Config{osname};
	$me->{osvers} = $Config{osvers};
	$me->{archname} = $Config{archname};

	_guessdistro($me);

	bless $me,$class;

	return $me;
}

sub dump {
	my $self = shift;

	my $osname = $self->{osname};

	printf "osname: %s\n", $osname;
	printf "osvers: %s\n", $self->{osvers};
	printf "archname: %s\n", $self->{archname};
	printf "archhw: %s\n", $self->{archhw};

	if($osname eq 'linux') {
		printf "  linux distro: %s\n", $self->{distro};
		printf "  distro revision: %s\n", $self->{distvers};
		printf "  kernel version: %s\n", $self->{kvers};
	}
}

sub main {
	my $obj = OpSys->new();
	$obj->dump();

}

__PACKAGE__->main() unless caller;

1;
__DATA__

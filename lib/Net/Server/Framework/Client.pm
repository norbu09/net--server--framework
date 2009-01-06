#!/usr/bin/perl -w -Ilib
#
# a General client library using the Net::Server::Framework framework
#

package Net::Server::Framework::Client;

use strict;
use warnings;
use Carp;
use IO::Socket;
use Net::Server::Framework::DB;
use Net::Server::Framework::Spooler;
use Time::HiRes;
use Data::Serializer;

our ($VERSION) = '1.0';

sub c_connect {
    my $service = shift;

    my @hosts = _find($service);
    foreach my $host (@hosts) {
        if ( $host->{host} eq 'unix' ) {
            return IO::Socket::UNIX->new( Peer => $host->{port}, )
              or next;
        }
        else {
            return IO::Socket::INET->new(
                Proto    => "tcp",
                PeerAddr => $host->{host},
                PeerPort => $host->{port},
            ) or next;
        }
    }
    carp("Could not find a valid connection method!");
}

sub encode {
    my $data = shift;
    my $s = Data::Serializer->new( compress => '1' );
    return $s->serialize($data);
}

sub decode {
    my $data = shift;
    my $s = Data::Serializer->new( compress => '1' );
    return $s->deserialize($data);
}

sub talk {
    my ( $mech, $data ) = @_;

    my $start = time();
    my $timeout = 15;
    my $remote = c_connect($mech)
      or carp( "cannot connect to $mech Daemon, check the config section in your program");

    # send the hash to the daemon
    print $remote encode($data);
    shutdown $remote, 1;
    my $resp = <$remote>;
    # we work in asyc mode and have to poll the queue
    if ($resp eq 'accepted')
    {
        while (1) {
            my $res = Net::Server::Framework::Spooler::virgin($data);
            return $res if defined $res;
            if ( time > $start + $timeout ) {
                return 1001;
            }
            Time::HiRes::usleep 100_000;
        }
    } else {
        return decode($resp);
    }
}

#TODO make logging in couchDB
sub logging {
    my $h = shift;
    return $h;
}

sub log {
    my $h = shift;
    $h->{command} = 'put';
    my $id = talk('logD', $h);
    return $h;
}

sub _find {
    my $service = shift;
    my $dbh     = Net::Server::Framework::DB::dbconnect('registry');
    my @ret;
    my $res =
      Net::Server::Framework::DB::get( { dbh => $dbh, key => 'host', term => $service } );
    foreach my $l ( keys %{$res} ) {
        my $ret;
        if ( $l eq '*' ) {
            if ( $res->{$l}->{port} =~ m{\d+} ) {
                $ret->{host} = 'localhost';
                $ret->{port} = $res->{$l}->{port};
            }
            else {
                $ret->{host} = 'unix';
                $ret->{port} = $res->{$l}->{port};
            }
        }
        else {
            $ret->{host} = $l;
            $ret->{port} = $res->{$l}->{port};
        }
        push( @ret, $ret );
    }
    return @ret;
}

1;

#!/usr/bin/perl -Ilib -w

package Net::Server::Framework::Auth;

use strict;
use warnings;
use Carp;
use Switch;
use Net::Server::Framework::DB;
use Net::Server::Framework::Crypt;

our ($VERSION) = '1.0';

sub authenticate {
    my ( $user, $token, $mode ) = @_;
    switch ($mode) {
        case /client/i { return ( _token( $user, $token ) ); }
        case /server/i { return ( _check( $user, $token ) ); }
        case /userpass/i { return ( _userpass( $user, $token ) ); }
        else { carp "2003"; }
    }
}

sub make_pass {
    my $pass = shift;
    return Net::Server::Framework::Crypt::hash($pass);
}

sub _check {
    my ( $user, $token ) = @_;
    my $dbh = Net::Server::Framework::DB::dbconnect('cloud');
    my $res = Net::Server::Framework::DB::get( { dbh => $dbh, key => 'auth', term => $user } );
    if ( my $pass = $res->{$user}->{password} ) {
        my $string = Net::Server::Framework::Crypt::decrypt( $token, $pass, 'blowfish', 'a' );
        print STDERR "DEBUG: $pass - $string\n";
        my ( $u, $time ) = split( /-/, $string, 2 );
        print STDERR "DEBUG: $u, $time\n";
        if ( $u eq $user ) {

            # more than one day time difference is too much
            if (    ( ( $time + 86400 ) gt time )
                and ( time gt( $time - 86400 ) ) )
            {
                return;
            }
        }
    }
    return 2200;
}

sub _token {
    my ( $user, $pass ) = @_;

    my $string = $user . "-" . time;
    my $token = Net::Server::Framework::Crypt::encrypt( $string, $pass, 'blowfish', 'a' );
    chomp($token);
    return $token;
}

sub _userpass {
    my ( $user, $token ) = @_;
    my $dbh = Net::Server::Framework::DB::dbconnect('cloud');
    my $res = Net::Server::Framework::DB::get( { dbh => $dbh, key => 'auth', term => $user } );
    if ( my $pass = $res->{$user}->{password} ) {
        if ( $token eq $pass ) {
            return;
        }
    }
    return 2200;
}

1;

